FROM ubuntu:14.04
# FROM nvidia/cuda:7.5-cudnn5-devel-ubuntu14.04

WORKDIR /usr/local/app
ENV WORKDIR /usr/local/app

RUN apt-get update
RUN apt-get install wget -fy
RUN apt-get install git -fy
RUN apt-get install vim -fy

# install Octave
RUN apt-get install octave -fy

# install CUDA
# RUN apt-get install -fy dictionaries-common
# RUN apt-get install -fy aspell
# RUN apt-get install -fy aspell-en
# RUN apt-get install -fy hunspell-en-us
# RUN apt-get install -fy libenchant1c2a:amd64
# RUN apt-get install -fy libwebkitgtk-3.0-0:amd64
# RUN apt-get install -fy enchant
# RUN apt-get install -fy libyelp0
# RUN apt-get install -fy yelp
# RUN apt-get install -fy gnome-user-guide
# RUN apt-get install -fy zenity
# RUN apt-get install -fy unity-control-center
# RUN apt-get install -fy unity-control-center-signon
# RUN apt-get install -fy indicator-bluetooth

# RUN apt-get install nvidia-cuda-toolkit -fy
# RUN wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1404-10-0-local-10.0.130-410.48_1.0-1_amd64
# RUN dpkg -i cuda-repo-ubuntu1404-10-0-local-10.0.130-410.48_1.0-1_amd64
# RUN apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
# RUN apt-get update
# RUN apt-get install cuda -fy

# install Torch
RUN apt-get install libmatio2 -fy
RUN apt-get install libprotobuf-dev -fy
RUN apt-get install protobuf-compiler -fy

RUN git clone https://github.com/torch/distro.git $WORKDIR/torch --recursive
WORKDIR /usr/local/app/torch
RUN TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__" bash install-deps && TORCH_LUA_VERSION=LUA51 bash ./install.sh
# RUN TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__" ./update.sh
RUN /bin/bash -c "source ~/.bashrc"
WORKDIR /usr/local/app

# install cudnn
# # https://www.dropbox.com/s/9zwrceri362c5no/cudnn-10.0-linux-x64-v7.3.1.20.tgz?dl=0
# COPY ./cudnn-10.0-linux-x64-v7.3.1.20.tgz .
# RUN tar -xzvf cudnn-10.0-linux-x64-v7.3.1.20.tgz
# RUN cp cuda/include/cudnn.h /usr/local/cuda/include
# RUN cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
# RUN chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# install styletransfer
RUN git clone https://github.com/luanfujun/deep-photo-styletransfer.git $WORKDIR/styletransfer
WORKDIR /usr/local/app/styletransfer
RUN sh ./models/download_models.sh
RUN make

# install loadcaffe
RUN luarocks install loadcaffe
RUN luarocks install image
RUN luarocks install torch
RUN luarocks install cutorch
