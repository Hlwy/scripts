#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

## Read in user defined inputs
read -p "Enter Name for Access Point: "  apName
echo "Access Point Name: $apName"

read -p "Enter Static IP address assigned to Access Point: "  apIp
echo "Access Point IP: $apIp"

read -p "Enter Interface for the Access Point: "  apIface
echo "Access Point Interface: $apIface"

ip1="$(echo $apIp | cut -d '.' -f 1)"
ip2="$(echo $apIp | cut -d '.' -f 2)"
ip3="$(echo $apIp | cut -d '.' -f 3)"
ip4="$(echo $apIp | cut -d '.' -f 4)"

sudo ifdown $apIface

# Remove any previous mention of interface
sed -i -- 's/allow-hotplug $apIface//g' /etc/network/interfaces
sed -i -- 's/iface $apIface inet manual//g' /etc/network/interfaces
sed -i -- 's/    wpa-conf \/etc\/wpa_supplicant\/wpa_supplicant.conf//g' /etc/network/interfaces

cat >> /etc/network/interfaces <<EOF

## Added by setup_wifi_ap.sh script ####
allow-hotplug $apIface
iface $apIface inet static
	address $ipAp
	netmask 255.255.255.0

EOF
