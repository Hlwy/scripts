#!/bin/sh
## MAKE SURE THIS IS EXECUTABLE
#export ROS_HOSTNAME="TheRedtop"
export ROS_IP="10.192.222.26"
export ROS_MASTER_URI="http://10.192.222.26:11311"
export ROSLAUNCH_SSH_UNKNOWN="1"
##. /opt/ros/distro/setup.sh
##. ~/your_workspace/devel/setup.sh
exec "$@"
