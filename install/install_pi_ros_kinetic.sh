#!/bin/bash

#################################################
#     Install Full ROS Kinetic for Ubuntu 16.04
#################################################

read -p "Do you need to install ROS? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     # Setup your sources.list
     sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

     # Setup your keys
     sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

     # Install Desktop-Full
     sudo apt-get update
     echo
     echo "Downloading dependencies for Pi"
     echo
     sleep 1

     sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake dirmngr

     # Initialize rosdep
     sudo rosdep init
     rosdep update

     # Make a ROS workspace
     echo
     echo "Making 'ros_ws' in your home directory..."
     echo
     sleep 1
     mkdir -p ~/ros_ws
     cd ~/ros_ws

     read -p "It is recommended to have at least 2Gb of extra swap RAM (most likely from a USB Drive), to prevent errors while building. If you would like extra swap space for building please insert a USB drive with extra swap now. Press Enter to continue....." doit
     echo

     read -p "Do you want to install (1) ROS-Comm or (2) ROS-Desktop? Enter (1) or (2)" doit
     echo
     if [[ $doit == "1"]]; then
          cd ~/ros_ws
          # Install ROS packages for ROS-comm
          echo
          echo "Downloading ROS packages (ros_comm)..."
          echo
          sleep 1
          rosinstall_generator ros_comm ros_control joy joystick_drivers joy_teleop teleop_twist_joy --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall

          echo
          echo "Initializing ROS workspace with packages..."
          echo
          sleep 1
          wstool init src kinetic-ros_comm-wet.rosinstall
     elif [[ $doit == "2"]]; then
          cd ~/ros_ws
          # Install Dependencies specific for ROS-Desktop on Raspbian Jessie to prevent build errors
          echo
          echo "Downloading Raspbain Jessie ROS-Desktop specific dependencies..."
          echo
          sleep 1

          echo
          echo "Downloading/Installing Collada dependencies..."
          echo
          sleep 1
          mkdir external_src
          cd external_src
          wget http://downloads.sourceforge.net/project/collada-dom/Collada%20DOM/Collada%20DOM%202.4/collada-dom-2.4.0.tgz
          tar xf collada-dom-2.4.0.tgz
          cd collada-dom-2.4.0/
          mkdir build
          cd build
          cmake ..
          make -j4
          sudo make install
          
          # Install ROS packages for ROS-Desktop
          echo
          echo "Downloading ROS packages (ros_desktop)..."
          echo
          sleep 1
          cd ~/ros_ws
          rosinstall_generator desktop perception_pcl --rosdistro kinetic --deps --wet-only --tar > kinetic-desktop-wet.rosinstall

          echo
          echo "Initializing ROS workspace with packages..."
          echo
          sleep 1
          wstool init src kinetic-desktop-wet.rosinstall

     else



     fi

     cd ~/ros_ws
     echo
     echo "Installing ROS dependencies..."
     echo
     sleep 1
     rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:jessie

     echo
     echo "Building ROS packages..."
     echo
     sleep 1
     sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DCMAKE_MODULE_PATH=/usr/share/cmake-3.0/Modules --install-space /opt/ros/kinetic -j2

     # rosinstall_generator desktop perception_pcl --rosdistro kinetic --deps --wet-only --exclude collada_parser collada_urdf --tar > kinetic-desktop-wet.rosinstall
     # rosinstall_generator desktop perception_pcl --rosdistro kinetic --deps --wet-only --exclude collada_parser collada_urdf --tar > kinetic-custom_ros.rosinstall
     # wstool merge -t src kinetic-custom_ros.rosinstall
     # wstool update -t src
     #
     # rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r --os=debian:jessie
     # sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DCMAKE_MODULE_PATH=/usr/share/cmake-3.0/Modules --install-space /opt/ros/kinetic -j2

     # Setup bash Environment Loading
     echo
     echo "Updating and sourcing your .bashrc ..."
     echo
     sleep 1
     source /opt/ros/kinetic/setup.bash
     echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
     source ~/.bashrc

     echo
     echo "ROS installation complete."
     echo
     sleep 1

fi

# #################################
# #     Additional Packages
# ################################
# read -n1 -p "Do you need to install the additional ROS packages? Enter (y) or (n)" doit
# echo
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      # Joystick drivers for robot control
#      sudo apt install ros-kinetic-joy ros-kinetic-joystick-drivers ros-kinetic-joy-teleop ros-kinetic-teleop-twist-joy
#      # Drivers for robot navigation
#      sudo apt install ros-kinetic-gmapping ros-kinetic-amcl ros-kinetic-move-base ros-kinetic-map-server ros-kinetic-hector-gazebo*
#
# fi
# echo
#
# ############################
# #  Clone Terrasentia Repo
# ############################
# read -n1 -p "Do you need to get the terrasentia-gazebo repo? Enter (y) or (n)" doit
# echo
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      echo Please type in your git or bitbucket username.
#      read username
#
#      cd $HOME
#      mkdir -p catkin_ws/src
#      cd catkin_ws/src
#
#      git clone https://$username@bitbucket.org/daslab_uiuc/terrasentia-gazebo.git
#      ros_ws=$HOME/catkin_ws
#
#      terra_gazebo_path="$ros_ws/src/terrasentia-gazebo"
#
# else
#      echo "What is the path to your working ROS workspace?"
#      read ros_ws
#
#      terra_gazebo_path="$ros_ws/src/terrasentia-gazebo"
# fi
# echo
# echo "The terrasentia-gazebo path: $terra_gazebo_path"
#
# ############################################
# #  Look for, or clone, libterra-simulator
# ############################################
# read -n1 -p "Do you need to get the terra-simulator repo? Enter (y) or (n)" doit
# echo
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      cd $HOME
#      mkdir devel
#      cd devel
#
#      echo Please type in your git or bitbucket username.
#      read username
#
#      git clone https://$username@bitbucket.org/daslab_uiuc/terra-simulator.git
#      swarm_dirs="$HOME/devel/terra-simulator/libterra-simulator/include"
# else
#
#      echo "What is the path to the terra-simulator repo?"
#      read terra_path
#      swarm_dirs="$terra_path/terra-simulator/libterra-simulator/include"
# fi
# echo
# echo "The local terra-simulator repo path: $swarm_dirs"
#
# read -n1 -p "Do you have a SwarmbotsConfig.user.cmake file? Enter (y) or (n)" doit
#
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      echo
#      echo "Good!"
# else
#      echo
#      echo "That is alright making one now...."
#
#      cd "$terra_gazebo_path/terrasentia_sensors"
#      printf "set(SWARMBOTS_DIRS $swarm_dirs)" > SwarmbotsConfig.user.cmake
#
# fi
# echo
# cat $terra_gazebo_path/terrasentia_sensors/SwarmbotsConfig.user.cmake
#
# ###########################
# #  	Build Everything
# ###########################
# echo
# read -n1 -p "Do you want to build your workspace? Enter (y) or (n)" doit
#
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      cd $ros_ws
#      catkin_make
#      source devel/setup.bash
# fi

echo
echo Done!
