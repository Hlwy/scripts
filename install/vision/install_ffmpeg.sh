#!/bin/bash

# Installation configured for Raspberry Pi 3 Model B
cd ~/Libraries
git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
sudo ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
make -j4
sudo make install

# wget https://github.com/ccrisan/motioneye/wiki/precompiled/ffmpeg_3.1.1-1_armhf.deb
# sudo dpkg -i ffmpeg_3.1.1-1_armhf.deb
