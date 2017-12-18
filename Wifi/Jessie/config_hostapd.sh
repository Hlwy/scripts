#!/bin/bash

# Check for sudo permissions
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

# Look for help sign
if [ "$1" == "-h" ]; then
  echo "Usage: $0 '$ap_name $interface'"
  exit 0
fi

# check for required argument (assigned AP SSID)
if [[ $# -lt 1 ]];
	then echo "You need to pass a SSID name to assign to your access point!"
	echo "Usage:"
	echo "sudo $0 desired_ssid [AP_interface]"
	exit
fi

# Store arguments for later usage
apName="$1"
apIface="wlan1"

# check for optional argument (assigned interface for AP)
if [[ $# -eq 2 ]]; then
	apIface=$2
fi

# Echo Inputs for debugging
echo "Access Point Name: $apName"
echo "Access Point Interface: $apIface"

## Read in user defined inputs
# read -p "Enter Name for Access Point: "  apName
# read -p "Enter Interface for the Access Point: "  apIface

# Create hostapd.conf backup
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.backup

# Modify Config files
sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat > /etc/hostapd/hostapd.conf <<EOF
interface=$apIface
ssid=$apName
driver=rtl871xdrv
ieee80211n=1
hw_mode=g
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
channel=7
EOF

# Reload hostapd
sudo systemctl daemon-reload
sudo service hostapd restart
