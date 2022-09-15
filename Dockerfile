FROM quay.io/astronomer/astro-runtime:5.0.8

USER root
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install software-properties-common
RUN curl -O https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
RUN add-apt-repository contrib
RUN apt-get update
RUN apt-get -y install cuda

RUN curl -O https://developer.download.nvidia.com/compute/redist/cudnn/v8.3.1/local_installers/11.5/cudnn-linux-x86_64-8.3.1.22_cuda11.5-archive.tar.xz

RUN tar -xvf cudnn-linux-x86_64-8.3.1.22_cuda11.5-archive.tar.xz
RUN cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include 
RUN cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 
RUN chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
USER astro

# wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.3.1/local_installers/11.5/cudnn-local-repo-ubuntu2004-8.3.1.22_1.0-1_amd64.deb
# sudo dpkg -i cudnn-local-repo-ubuntu2004-8.3.1.22_1.0-1_amd64.deb
# sudo apt-get update
# sudo apt-get install -y libcudnn8=8.3.1.22-1+cuda11.5 libcudnn8-dev=8.3.1.22-1+cuda11.5