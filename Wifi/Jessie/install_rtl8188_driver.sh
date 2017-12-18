#!/bin/bash

sudo wget http://www.fars-robotics.net/install-wifi -O /usr/bin/install-wifi
sudo chmod +x /usr/bin/install-wifi
sudo install-wifi -u r8188eu
sudo install-wifi r8188eu
