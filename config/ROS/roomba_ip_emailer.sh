#!/bin/bash
# a script for sending myself an email containing my IP address
> whereami.txt
echo "My internal IP address is:" >> whereami.txt ; ifconfig | grep -Po "inet addr:.+Bcast" | grep -Po '(?:\d{1,3}\.){3}\d{1,3}' >> whereami.txt

sendEmail -f huntery2@illinois.edu -t huntery2@illinois.edu -o message-file=whereami.txt -v -s smtp.illinois.edu:587 -xu 'huntery2' -xp 'Hlwy!992'

myip=$(ifconfig | grep -A 1 'wlan0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)
echo $myip

export ROS_IP="$(echo $myip)"
