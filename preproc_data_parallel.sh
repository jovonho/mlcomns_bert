#!/bin/bash

# To be run in the docker container
# Needs /raw-data, /wiki and /data mounted, with >365 GiB available in /data

# This script will spawn 10 batches of 50 processes to create Tfrecords from the raw data

DATA_DIR="/raw-data"
WIKI_DIR="/wiki"
OUTPUT_DIR="/data"
RANDOM_SEED=12345

pushd cleanup_scripts

echo -e "Generating TFRecords for training set"

for batch in {0..9}
do
  echo -e "Batch $batch of 10"
  for n in {0..49}
  do
    part_num=$(( 50 * $batch + $n ))
    part_num=$( printf "%05d" $part_num )
    echo -en "\tPreprocessing part-$part_num\n"

    # run process in bg
    python create_pretraining_data.py \
    --input_file=${DATA_DIR}/part-${part_num}-of-00500 \
    --output_file=${OUTPUT_DIR}/part-${part_num}-of-00500 \
    --vocab_file=${WIKI_DIR}/vocab.txt \
    --do_lower_case=True \
    --max_seq_length=512 \
    --max_predictions_per_seq=76 \
    --masked_lm_prob=0.15 \
    --random_seed=${RANDOM_SEED} \
    --dupe_factor=10 &

    # Store PID in array
    pids[${n}]=$!
  done

  # wait for all pids
  for pid in ${pids[*]}; do
      wait $pid
  done

done

echo -e "Generating TFRecords for eval set"

python create_pretraining_data.py \
  --input_file=${DATA_DIR}/eval.txt \
  --output_file=${DATA_DIR}/eval_intermediate \
  --vocab_file=${WIKI_DIR}/vocab.txt \
  --do_lower_case=True \
  --max_seq_length=512 \
  --max_predictions_per_seq=76 \
  --masked_lm_prob=0.15 \
  --random_seed=${RANDOM_SEED} \
  --dupe_factor=10

python pick_eval_samples.py \
  --input_tfrecord=${DATA_DIR}/eval_intermediate \
  --output_tfrecord=${OUTPUT_DIR} \
  --num_examples_to_pick=10000


popd
echo -e "All done!"
