#!/bin/bash

#TODO: Parametrize num_gpus and mount points
docker run -it --name=train_bert --gpus all -v /data/bert/wiki:/wiki -v /data/bert/raw-data:/raw-data -v /raid/data/bert/preproc_data:/data -v /raid/data/bert/output:/output tf-bert:latest /bin/bash train_model.sh
