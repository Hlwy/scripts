#!/bin/bash

# Look for help sign
if [ "$1" == "-h" ]; then
  echo "Usage: $0 '$masteruri $myip'"
  exit 0
fi

# check for required argument (assigned static IP address)
if [[ $# -lt 1 ]];
	then echo "You need to pass the uri of the ROS Master!  [e.x http://192.168.1.1:11311]"
	echo "Usage:"
	echo "sudo $0 master_uri my_ip [hostname]"
	exit
fi

# check for required argument (assigned AP SSID)
if [[ $# -lt 2 ]];
	then echo "You need to pass the ip associated with this device! [e.x 192.168.1.2]"
	echo "Usage:"
	echo "sudo $0 master_uri my_ip [hostname]"
	exit
fi

# Store arguments for later usage
masterUri="$1"
myIp="$2"
# hostname="wlan1"

echo "Master Uri: $masterUri"
echo "My ip: $myIp"

## MAKE SURE THIS IS EXECUTABLE
export ROS_MASTER_URI="http://$masterUri:11311"
export ROS_IP=$myIp
#export ROS_HOSTNAME="TheRedtop"
export ROSLAUNCH_SSH_UNKNOWN="1"

# myip=$(ifconfig | grep -A 1 'wlan0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)
# export ROS_IP="$(echo $myip)"

# exec "$@"
