FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    bison \
    zlib1g-dev \
    libglu1-mesa-dev \
    gcc \
    g++ \
    make \
    xutils-dev \
    bison \
    flex \
    zlib1g-dev \
    python3 \
    python3-pip \
    doxygen \
    wget \
    cmake \
    graphviz \ 
    git 

#RUN apt-get install -y \
    #python-pmw  \
    #python-ply  \
    #python-numpy  \
    #libpng-dev  \
    #python-matplotlib

# CUDA SDK deps
RUN apt-get update && \
    apt-get install -y \
    libxi-dev \
    libxmu-dev 
    
RUN apt-get update && \
    apt-get install -y \
    vim

#libglut3-dev


# FILE STRUCTURE STUFF #

# make Repos dir
RUN cd ~ && \
    mkdir Repos 

##################
## NVIDIA STUFF ##
##################

# Install cuda 9.1

RUN wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64 && \
    dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64 && \
    apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y cuda && \
    rm -rf /var/lib/apt/lists/*

# cudnn 7.0.5 
# library
RUN wget https://developer.download.nvidia.com/compute/redist/cudnn/v7.0.5/Ubuntu16_04-x64/libcudnn7_7.0.5.15-1+cuda9.1_amd64.deb && \
    dpkg -i libcudnn7_7.0.5.15-1+cuda9.1_amd64.deb 

RUN wget https://developer.download.nvidia.com/compute/redist/cudnn/v7.0.5/Ubuntu16_04-x64/libcudnn7-dev_7.0.5.15-1+cuda9.1_amd64.deb && \
    dpkg -i libcudnn7-dev_7.0.5.15-1+cuda9.1_amd64.deb

# runtime
#RUN wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.1_20171129/Ubuntu16_04-x64/libcudnn7_7.0.5.15-1+cuda9.1_amd64 && \
    #dpkg -i libcudnn7_7.0.5.15-1+cuda9.1_amd64

# dev library
#RUN wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.1_20171129/Ubuntu16_04-x64/libcudnn7-dev_7.0.5.15-1+cuda9.1_amd64%0D%0A && \
    #dpkg -i libcudnn7-dev_7.0.5.15-1+cuda9.1_amd64

# examples 
#RUN wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.1_20171129/Ubuntu16_04-x64/libcudnn7-doc_7.0.5.15-1+cuda9.1_amd64 && \
    #dpkg -i libcudnn7-doc_7.0.5.15-1+cuda9.1_amd64 



###############
## GPGPU SIM ##
###############

SHELL ["/bin/bash", "-c"] 

# SET ENV STUFF #

# I also dont know if this is correct (cuda vs cuda-9.1?)
ENV CUDA_INSTALL_PATH=/usr/local/cuda-9.1/
ENV PATH=$CUDA_INSTALL_PATH/bin:$PATH

# IDK if this is correct tbh
ENV CUDNN_PATH=/usr/include/
ENV LD_LIBRARY_PATH=$CUDA_INSTALL_PATH/lib64:$CUDA_INSTALL_PATH/lib:$CUDNN_PATH/lib64

ENV export CUDNN_INCLUDE_DIR=/usr/include/
ENV export CUDNN_LIBRARY=/usr/lib/x86_64-linux-gnu/

# CLONE AND BUILD GPGPU #
RUN cd ~/Repos && \
    git clone https://github.com/gpgpu-sim/gpgpu-sim_distribution.git && \
    cd gpgpu-sim_distribution && \
    bash && \
    source setup_environment release && \
    make -j 12




# GPGPU SIM PYTORCH STUFF #

ENV TORCH_CUDA_ARCH_LIST="6.1+PTX" 

#RUN pip3 install torchvision==0.2.2
#RUN pip3 uninstall torch

# install python libs
ENV DEBIAN_FRONTEND=dialog
