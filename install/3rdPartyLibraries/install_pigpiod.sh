#!/bin/bash

read -n1 -p "Do you need to install PiGpiod? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     echo
     echo "Building and Installing pigpiod from source..."
     echo
     mkdir ~/Libraries
     cd ~/Libraries
     sudo rm -rf PIGPIO
     wget abyz.co.uk/rpi/pigpio/pigpio.tar
     tar xf pigpio.tar
     cd PIGPIO
     make -j4
     sudo make install
     rm ~/Libraries/pigpio.tar
fi
echo
echo "pigpiod Installed"
echo
