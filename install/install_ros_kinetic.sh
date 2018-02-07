#!/bin/bash

#################################################
#     Install Full ROS Kinetic for Ubuntu 16.04
#################################################


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
# Drivers for robot navigation
sudo apt install ros-kinetic-gmapping ros-kinetic-amcl ros-kinetic-move-base ros-kinetic-map-server ros-kinetic-hector-gazebo*

#############################################
#  Create Catkin Workspace for ROS Packages
############################################

cd $HOME
mkdir -p catkin_ws/src
cd catkin_ws/src

############################
#  Clone Terrasentia Repo
############################

echo Please type in your git or bitbucket username.
read username

git clone https://$username@bitbucket.org/daslab_uiuc/terrasentia-gazebo.git

############################################
#  Look for, or clone, libterra-simulator
############################################

read -p "Path to \'libterra-simulator/include\' (If you do not have it, just leave this blank): " libterraPath
if [[ "$libterraPath" == "NULL" ]] ; then 
  echo Making directory 'home/devel/'
  mkdir
  libterraPath = $HOME/devel/
fi


###########################
#  	Build Everything
###########################
catkin_make
source devel/setup.bash
