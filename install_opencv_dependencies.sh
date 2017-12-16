#!/bin/bash
# Install Other System Dependencies

sudo apt-get update
# Build tools:
sudo apt-get install -y build-essential git cmake pkg-config unzip wget
# Media I/O:
sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
# Video I/O:
sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libatlas-base-dev gfortran
# Python:
sudo apt-get install -y python2.7-dev python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
# pip install numpy
pip install gevent
pip install gunicorn

# GUI
sudo apt-get install -y libgtkglext1-dev libvtk6-dev
# Parallelism and linear algebra libraries:
sudo apt-get install -y libtbb-dev libeigen3-dev
# Java:
sudo apt-get install -y ant default-jdk
# Documentation:
sudo apt-get install -y doxygen
