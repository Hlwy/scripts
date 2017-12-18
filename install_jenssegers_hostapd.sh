#!/bin/bash

sudo apt-get install -y hostapd
sudo apt-get autoremove hostapd

cd ~/Libraries
wget https://github.com/jenssegers/RTL8188-hostapd/archive/v2.0.tar.gz
tar -zxvf v2.0.tar.gz
cd ~/Libraries/RTL8188-hostapd-2.0/hostapd

sudo make -j4
sudo make install
