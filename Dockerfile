# python version 3.6.9
# CUDA9.0, CUDNN7
# UBUNTU 16.04
# GCC 5.4 I think

FROM songhesd/cuda:9.0-cudnn7-devel-ubuntu16.04

SHELL ["/bin/bash", "-c"]

# SET ENVIRONMENT STUFF 

ENV CUDA_INSTALL_PATH=/usr/local/cuda
ENV PATH=$CUDA_INSTALL_PATH/bin:$PATH

ENV CUDNN_PATH=/usr/include/
ENV LD_LIBRARY_PATH=$CUDA_INSTALL_PATH/lib64:$CUDA_INSTALL_PATH/lib:$CUDNN_PATH/lib64

ENV CUDNN_INCLUDE_DIR=/usr/include/
ENV CUDNN_LIBRARY=/usr/lib/x86_64-linux-gnu/libcudnn.so
ENV CUDNN_LIB_DIR=/usr/lib/x86_64-linux-gnu/

RUN apt-get update && apt-get install -y --no-install-recommends \
        cmake \
        git \
        curl \
        vim \
        ca-certificates \
        libjpeg-dev \
        libpng-dev &&\
        rm -rf /var/lib/apt/lists/*

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
    python-pip \
    python3-dev \
    python3-pip \
    doxygen \
    wget \
    cmake \
    graphviz \ 
    git 

RUN apt-get update && \
    apt-get install -y \
    python-pmw  \
    python-ply  \
    python-numpy \
    libpng-dev \
    python-matplotlib

# CUDA SDK deps
RUN apt-get update && \
    apt-get install -y \
    libxi-dev \
    libxmu-dev 
    
RUN apt-get update && \
    apt-get install -y \
    vim

# Make a Repos directory
RUN mkdir ~/Repos

#########
# CONDA #
#########

RUN curl https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -o ~/miniconda.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/miniconda && \
    rm ~/miniconda.sh

ENV PATH="/opt/miniconda/bin:$PATH"

# Create a 3.6.9 python env
RUN conda create -y -n env python=3.6.9

# Install pre-recs
# Important, pyyaml 3.13 is REQUIRED (otherwise build will break)
RUN source activate env && \
    pip install numpy pyyaml==3.13 scipy ipython mkl mkl-include
    #pip install magma-cuda90

RUN apt-get install -y build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev \
    doxygen graphviz python-pmw python-ply python-numpy libpng12-dev \
    python-matplotlib libxi-dev libxmu-dev



###############
## GPGPU SIM ##
###############
RUN source activate env && cd ~/Repos && \
    git clone https://github.com/gpgpu-sim/gpgpu-sim_distribution.git && \
    cd gpgpu-sim_distribution && \
    git checkout tags/v4.2.1 && \
    bash && \
    source setup_environment release && \
    make -j 12

#############
## PYTORCH ##
#############


#ENV TORCH_CUDA_ARCH_LIST="7.0+PTX"

RUN source activate env && cd ~/Repos && \
    git clone https://github.com/gpgpu-sim/pytorch-gpgpu-sim.git && \
    cd pytorch-gpgpu-sim && \
    pip install torchvision==0.2.2 && pip uninstall torch && \
    git -c submodule."third_party/nervanagpu".update=none submodule update --init && \
    python setup.py install 








# Install basic dependencies
#conda install numpy pyyaml mkl mkl-include setuptools cmake cffi typing
#conda install -c mingfeima mkldnn

## Add LAPACK support for the GPU
#conda install -c pytorch magma-cuda80 # or magma-cuda90 if CUDA 9

## This must be done before pip so that requirements.txt is available
#WORKDIR /opt/pytorch
#COPY . .

#RUN git submodule update --init
#RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    #CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    #pip install -v .

#RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .

#WORKDIR /workspace
#RUN chmod -R a+w /workspace
