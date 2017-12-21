#!/bin/bash

# Setup your sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Setup your keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Install Desktop-Full
sudo apt-get update
sudo apt-get install -y ros-kinetic-desktop-full

# Initialize rosdep
sudo rosdep init
rosdep update

# Setup bash Environment Loading
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
source /opt/ros/kinetic/setup.bash


#################################
#     Additional Packages
################################

# Joystick drivers for robot control
sudo apt install ros-kinetic-joy ros-kinetic-joystick-drivers ros-kinetic-joy-teleop ros-kinetic-teleop-twist-joy
