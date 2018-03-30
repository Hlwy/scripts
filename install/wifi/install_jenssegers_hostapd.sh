#!/bin/bash

sudo apt autoremove -y hostapd

cd /home/hunter/Libraries
wget https://github.com/jenssegers/RTL8188-hostapd/archive/v2.0.tar.gz
tar -zxvf v2.0.tar.gz
cd /home/hunter//Libraries/RTL8188-hostapd-2.0/hostapd

sudo make -j4
sudo make install
rm /home/hunter/Libraries/v2.0.tar.gz
