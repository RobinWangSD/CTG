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

# # Install (mini) conda
# RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh && \
#     /opt/conda/bin/conda init && \
#     /opt/conda/bin/conda install -y python="$PYTHON_VERSION" && \
#     /opt/conda/bin/conda clean -ya

# ENV PATH /opt/conda/bin:$PATH
SHELL ["/bin/bash", "-c"]
