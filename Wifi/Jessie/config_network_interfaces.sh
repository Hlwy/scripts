#!/bin/bash

# Check for sudo permissions
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

# Look for help sign
if [ "$1" == "-h" ]; then
  echo "Usage: $0 '$ip $interface'"
  exit 0
fi

# check for required argument (assigned static IP address)
if [[ $# -lt 1 ]];
	then echo "You need to pass a static IP address to assign to your access point!"
	echo "Usage:"
	echo "sudo $0 desired_ip [AP_interface]"
	exit
fi

# Store arguments for later usage
apIp="$1"
apIface="wlan1"

# check for optional argument (assigned interface for AP)
if [[ $# -eq 2 ]]; then
	apIface=$2
fi
## Echo Inputs for debugging
echo "Access Point IP: $apIp"
echo "Access Point Interface: $apIface"

## Optional: Read in user defined inputs
# read -p "Enter Static IP address assigned to Access Point: "  apIp
# read -p "Enter Interface for the Access Point: "  apIface

ip1="$(echo $apIp | cut -d '.' -f 1)"
ip2="$(echo $apIp | cut -d '.' -f 2)"
ip3="$(echo $apIp | cut -d '.' -f 3)"
ip4="$(echo $apIp | cut -d '.' -f 4)"

sudo ifdown $apIface

# Create a backup
cp /etc/network/interfaces /etc/network/interfaces.backup

# Remove any previous mention of interface
sed -i -- "s/allow-hotplug $apIface//g" /etc/network/interfaces
sed -i -- "s/iface $apIface inet manual//g" /etc/network/interfaces
# sed -i -- 's/    wpa-conf \/etc\/wpa_supplicant\/wpa_supplicant.conf//g' /etc/network/interfaces

cat >> /etc/network/interfaces <<EOF

## Added by setup_wifi_ap.sh script ####
allow-hotplug $apIface
iface $apIface inet static
	address $apIp
	netmask 255.255.255.0

pre-up iptables-restore < /etc/iptables.ipv4.nat

EOF

sudo ifup $apIface
