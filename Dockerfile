# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/pytorch:22.02-py3

# Run apt-get (dkpg) without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim git curl wget yasm cmake unzip pkg-config \
    checkinstall build-essential ca-certificates \
    software-properties-common apt-utils bash-completion \
    apt-transport-https gnupg sudo \
    libeigen3-dev \
  && apt-get upgrade -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install opencv dependencies
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Setup locale language config
RUN apt-get update && apt-get install -y --no-install-recommends locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen "en_US.UTF-8" \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime  # Set timezone
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /root
RUN conda create -n bg3.9 python=3.9 \ 
    && git clone https://github.com/RobinWangSD/CTG.git \
    && cd CTG \
    && /opt/conda/envs/bg3.9/bin/pip3 install -e . \
    && /opt/conda/envs/bg3.9/bin/pip3 install numpy==1.23.4 \
    && cd .. \
    && git clone https://github.com/AIasd/trajdata.git \
    && cd trajdata \
    && /opt/conda/envs/bg3.9/bin/pip3 install -r trajdata_requirements.txt \
    && /opt/conda/envs/bg3.9/bin/pip3 install -e . \
    && cd .. \
    && git clone https://github.com/NVlabs/spline-planner.git Pplan \
    && cd Pplan \
    && /opt/conda/envs/bg3.9/bin/pip3 install -e . \
    && cd .. \
    && git clone https://github.com/StanfordASL/stlcg.git \
    && cd stlcg \
    && /opt/conda/envs/bg3.9/bin/pip3 install graphviz \
    && /opt/conda/envs/bg3.9/bin/pip3 install -e . \
    && git checkout dev \
    && /opt/conda/envs/bg3.9/bin/pip3 install openai \
    && /opt/conda/envs/bg3.9/bin/pip3 install tiktoken

SHELL ["/bin/bash", "-c"]
