#!/bin/bash

cd ~/Libraries
sudo rm -rf PIGPIO
wget abyz.co.uk/rpi/pigpio/pigpio.tar
tar xf pigpio.tar
cd PIGPIO
make -j4
sudo make install
rm pigpio.zip
