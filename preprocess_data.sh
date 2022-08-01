#!/bin/bash

# To be run in the docker container
# Needs /raw-data, /wiki and /data mounted, with >365 GiB available in /data

DATA_DIR="/raw-data"
WIKI_DIR="/wiki"
OUTPUT_DIR="/data"
RANDOM_SEED=12345

pushd cleanup_scripts

echo "Generating TFRecords for training set\n"

for num in {001..500}
do
    echo "Preprocessing part-00${num}\n"

    python create_pretraining_data.py \
    --input_file=${DATA_DIR}/part-00${num}-of-00500 \
    --output_file=${OUTPUT_DIR}/part-00${num}-of-00500 \
    --vocab_file=${WIKI_DIR}/vocab.txt \
    --do_lower_case=True \
    --max_seq_length=512 \
    --max_predictions_per_seq=76 \
    --masked_lm_prob=0.15 \
    --random_seed=${RANDOM_SEED} \
    --dupe_factor=10
done

echo "Generating TFRecords for eval set\n"

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
echo "All done!\n"
