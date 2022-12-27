#!/bin/bash

sudo apt-get update
sudo apt install vim

echo PS1='\u:\W\$ ' >> ~/.bashrc
conda init
source ~/.bashrc

# https://rapids.ai/start.html#get-rapids
conda create -n rapids-22.12 -c rapidsai -c conda-forge -c nvidia  \
    rapids=22.12 python=3.9 cudatoolkit=11.4
conda install -n rapids-22.12 ipykernel --update-deps --force-reinstall
conda activate rapids-22.12

nvidia-smi