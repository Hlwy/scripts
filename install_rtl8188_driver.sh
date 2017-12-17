#!/bin/bash

# # Output system info for user info
# uname -a
#
# # Let user define the kernel version info manually for now
# read -p "Enter Kernel Version: "  kerVer
# echo "Kernel Version: $kerVer"
#
# read -p "Enter Kernel Build #: "  kerNum
# echo "Kernel Build #: $kerNum"
#
# # Get Dongle Driver from source
# cd ~/Libraries
# wget http://www.fars-robotics.net/8188eu-$kerVer-$kerNum.tar.gz
# tar xzf 8188eu-$kerVer-$kerNum.tar.gz
cd ~/Libraries
mkdir RTL8188
cd RTL8188
sudo wget http://www.fars-robotics.net/install-wifi -O /usr/bin/install-wifi
sudo chmod +x /usr/bin/install-wifi
