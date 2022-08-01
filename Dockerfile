FROM tensorflow/tensorflow:1.15.2-gpu

ADD . /workspace/bert
WORKDIR /workspace/bert

RUN pip install --upgrade pip