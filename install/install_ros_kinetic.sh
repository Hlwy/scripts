#!/bin/bash

#################################################
#     Install Full ROS Kinetic for Ubuntu 16.04
#################################################

read -n1 -p "Do you need to install ROS? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
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
fi

#################################
#     Additional Packages
################################
read -n1 -p "Do you need to install the additional ROS packages? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     # Joystick drivers for robot control
     sudo apt install ros-kinetic-joy ros-kinetic-joystick-drivers ros-kinetic-joy-teleop ros-kinetic-teleop-twist-joy
     # Drivers for robot navigation
     sudo apt install ros-kinetic-gmapping ros-kinetic-amcl ros-kinetic-move-base ros-kinetic-map-server ros-kinetic-hector-gazebo*

fi
echo

############################
#  Clone Terrasentia Repo
############################
read -n1 -p "Do you need to get the terrasentia-gazebo repo? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     echo Please type in your git or bitbucket username.
     read username

     cd $HOME
     mkdir -p catkin_ws/src
     cd catkin_ws/src

     git clone https://$username@bitbucket.org/daslab_uiuc/terrasentia-gazebo.git
     ros_ws=$HOME/catkin_ws

     terra_gazebo_path="$ros_ws/src/terrasentia-gazebo"

else
     echo "What is the path to your working ROS workspace?"
     read ros_ws

     terra_gazebo_path="$ros_ws/src/terrasentia-gazebo"
fi
echo
echo "The terrasentia-gazebo path: $terra_gazebo_path"

############################################
#  Look for, or clone, libterra-simulator
############################################
read -n1 -p "Do you need to get the terra-simulator repo? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     cd $HOME
     mkdir devel
     cd devel

     echo Please type in your git or bitbucket username.
     read username

     git clone https://$username@bitbucket.org/daslab_uiuc/terra-simulator.git
     swarm_dirs="$HOME/devel/terra-simulator/libterra-simulator/include"
else

     echo "What is the path to the terra-simulator repo?"
     read terra_path
     swarm_dirs="$terra_path/terra-simulator/libterra-simulator/include"
fi
echo
echo "The local terra-simulator repo path: $swarm_dirs"

read -n1 -p "Do you have a SwarmbotsConfig.user.cmake file? Enter (y) or (n)" doit

if [[ $doit == "Y" || $doit == "y" ]]; then
     echo
     echo "Good!"
else
     echo
     echo "That is alright making one now...."

     cd "$terra_gazebo_path/terrasentia_sensors"
     printf "set(SWARMBOTS_DIRS $swarm_dirs)" > SwarmbotsConfig.user.cmake

fi
echo
cat $terra_gazebo_path/terrasentia_sensors/SwarmbotsConfig.user.cmake

###########################
#  	Build Everything
###########################
echo
read -n1 -p "Do you want to build your workspace? Enter (y) or (n)" doit

if [[ $doit == "Y" || $doit == "y" ]]; then
     cd $ros_ws
     catkin_make
     source devel/setup.bash
fi

echo
echo Done!

