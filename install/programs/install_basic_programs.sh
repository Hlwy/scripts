#!/bin/bash

# Grub Customizer
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt-get update
sudo apt-get install grub-customizer

# System Monitor Indicator
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
sudo apt-get update
sudo apt-get install indicator-sysmonitor

# Nvidia Indicator
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install prime-indicator-plus

# Google Chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f

#if [[ $(getconf LONG_BIT) = "64" ]]
#then
#    echo "64bit Detected" &&
#    echo "Installing Google Chrome" &&
#    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
#    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
#    rm -f google-chrome-stable_current_amd64.deb
#fi

# Teamviewer 12
cd /tmp
wget https://download.teamviewer.com/download/teamviewer_i386.deb
sudo dpkg -i teamviewer_i386.deb
sudo apt install -f


# Atom Editor
sudo apt install snap
snap install atom --classic
