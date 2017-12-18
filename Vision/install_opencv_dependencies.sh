#!/bin/bash

# Install Other System Dependencies
sudo apt-get update

# Build tools:
sudo apt-get install -y build-essential git cmake pkg-config unzip wget

# Media I/O:
sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

# Video I/O:
sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# GStreamer
sudo apt install -y gstreamer0.10-* libgstreamer0.10-* libgstreamer-plugins-base0.10-*

# Python:
sudo apt-get install -y python2.7-dev python-dev python-tk python-numpy python-gunicorn python3-dev python3-tk python3-numpy

# GUI
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libgtkglext1-dev libvtk6-dev

# Parallelism and linear algebra libraries:
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y libeigen3-dev
sudo apt install -y libtbb2 libtbb-dev

# Java:
sudo apt-get install -y ant default-jdk
# Following section had to be done due to some install errors
sudo apt purge -y openjdk-8-jre-headless
sudo apt install -y openjdk-8-jre-headless
sudo apt install -y openjdk-8-jre

# Documentation:
sudo apt-get install -y doxygen

# Install Python Dependencies
sudo pip install gevent --upgrade
sudo pip install futures --upgrade
sudo pip install Flask --upgrade
sudo pip install numpy --upgrade
