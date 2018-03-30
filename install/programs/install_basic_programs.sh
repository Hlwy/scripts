#!/bin/bash

# Grub Customizer
read -n1 -p "Do you want to install grub-customizer? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     sudo add-apt-repository ppa:danielrichter2007/grub-customizer
     sudo apt update
     sudo apt install grub-customizer
     echo
fi

# System Monitor Indicator
read -n1 -p "Do you want to install indicator-sysmonitor? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
     sudo apt update
     sudo apt install indicator-sysmonitor
     echo
fi

# Nvidia Indicator
read -n1 -p "Do you want to install prime-indicator-plus? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     sudo add-apt-repository ppa:nilarimogard/webupd8
     sudo apt update
     sudo apt install prime-indicator-plus
     echo
fi

# Google Chrome
read -n1 -p "Do you want to install Google Chrome? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     cd /tmp
     wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
     sudo dpkg -i google-chrome-stable_current_amd64.deb
     sudo apt install -f
     echo
     #if [[ $(getconf LONG_BIT) = "64" ]]
     #then
     #    echo "64bit Detected" &&
     #    echo "Installing Google Chrome" &&
     #    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
     #    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
     #    rm -f google-chrome-stable_current_amd64.deb
     #fi
fi


# Teamviewer 12
read -n1 -p "Do you want to install Teamviewer 12? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     cd /tmp
     wget https://download.teamviewer.com/download/teamviewer_i386.deb
     sudo dpkg -i teamviewer_i386.deb
     sudo apt install -f
     echo
fi

# Atom Editor
read -n1 -p "Do you want to install Atom Editor? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     sudo apt install snap
     snap install atom --classic
     echo
fi

# Terminator
read -n1 -p "Do you want to install Terminator? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     sudo add-apt-repository ppa:gnome-terminator
     sudo apt update
     sudo apt install -y terminator
     echo
fi
