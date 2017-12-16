#!/bin/bash

# Installation configured for Raspberry Pi 3 Model B
cd ~/Libraries
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make -j4
sudo make install
