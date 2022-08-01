#/bin/bash

docker run -it --gpus all -v /data/bert/wiki:/wiki -v /data/bert/raw-data:/raw-data -v /raid/data/bert/preproc_data:/data -v /raid/data/bert/output:/output tf-bert:latest
