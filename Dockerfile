FROM ubuntu:18.04

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

# Install cuda 10.1

RUN wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb && \
    apt-key add /var/cuda-repo-10-1-local-10.1.105-418.39/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y cuda


## cudnn 7.0.5 
# library
RUN wget https://developer.download.nvidia.com/compute/redist/cudnn/v7.5.1/Ubuntu18_04-x64/libcudnn7_7.5.1.10-1+cuda10.1_amd64.deb && \
    dpkg -i libcudnn7_7.5.1.10-1+cuda10.1_amd64.deb 

# dev
RUN wget https://developer.download.nvidia.com/compute/redist/cudnn/v7.5.1/Ubuntu18_04-x64/libcudnn7-dev_7.5.1.10-1+cuda10.1_amd64.deb && \
    dpkg -i libcudnn7-dev_7.5.1.10-1+cuda10.1_amd64.deb




SHELL ["/bin/bash", "-c"] 

# SET ENV STUFF #

# I also dont know if this is correct (cuda vs cuda-10.1?)
ENV CUDA_INSTALL_PATH=/usr/local/cuda-10.1/
ENV PATH=$CUDA_INSTALL_PATH/bin:$PATH

#IDK if this is correct tbh
ENV CUDNN_PATH=/usr/include/
ENV LD_LIBRARY_PATH=$CUDA_INSTALL_PATH/lib64:$CUDA_INSTALL_PATH/lib:$CUDNN_PATH/lib64

ENV CUDNN_INCLUDE_DIR=/usr/include/
ENV CUDNN_LIBRARY=/usr/lib/x86_64-linux-gnu/libcudnn.so
ENV CUDNN_LIB_DIR=/usr/lib/x86_64-linux-gnu/


# Install gcc-5 & g++-5 #
RUN apt install g++-5
RUN apt install gcc-5


###############
## GPGPU SIM ##
###############

# CLONE AND BUILD GPGPU #
RUN cd ~/Repos && \
    git clone https://github.com/gpgpu-sim/gpgpu-sim_distribution.git && \
    cd gpgpu-sim_distribution && \
    bash && \
    source setup_environment release && \
    make -j 12

# GPGPU SIM PYTORCH #
RUN cd ~/Repos && \
    git clone https://github.com/HakamAtassi/pytorch-gpgpu-sim.git && \
    cd ~/Repos/pytorch-gpgpu-sim && \
    git -c submodule."third_party/nervanagpu".update=none submodule update --init


RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade Pillow

ENV TORCH_CUDA_ARCH_LIST="6.1+PTX" 
RUN apt update
RUN pip install numpy
RUN pip install torchvision==0.2.2
RUN pip uninstall torch -y

RUN cd ~/Repos/pytorch-gpgpu-sim && \
    python3 setup.py install

RUN pip install pyyaml

ENV PYTORCH_BIN=~/Repos/pytorch-gpgpu-sim/torch/lib/libcaffe2_gpu.so

# install python libs
ENV DEBIAN_FRONTEND=dialog


#https://askubuntu.com/questions/26498/how-to-choose-the-default-gcc-and-g-version