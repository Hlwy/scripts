#!/bin/sh
echo 'Killing previous pigpio daemon...'
sudo pkill pigpiod
echo 'Starting pigpio daemon...'
sudo pigpiod
cd Swarm/RoboDev/Controllers/4WD/
echo 'Starting robot control code....'
./Test4WD
echo 'Robot Running....'