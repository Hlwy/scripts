#!/bin/sh
echo 'Killing previous pigpio daemon...'
sudo pkill pigpiod
echo 'Starting pigpio daemon...'
sudo pigpiod
echo 'Running robot control code....'
cd /home/hunter/devel/RoboDev/Controllers/4WD/
sleep 1s
./Test4WD
echo 'Script Ended!'