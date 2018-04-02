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

# Echo Inputs for debugging
echo "Access Point IP: $apIp"
echo "Access Point Interface: $apIface"

# Ask for user-customized interface name
# read -p "Enter Static IP address assigned to Access Point: "  apIp
# read -p "Enter Interface for the Access Point: "  apIface

# Install DHCP server if not already installed
sudo apt install -y isc-dhcp-server

# Break down user-inputted IP address to 4 parts for dhcp customization later on in script
ip1="$(echo $apIp | cut -d '.' -f 1)"
ip2="$(echo $apIp | cut -d '.' -f 2)"
ip3="$(echo $apIp | cut -d '.' -f 3)"
ip4="$(echo $apIp | cut -d '.' -f 4)"

# Create hostapd.conf backup
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup

## Configure DHCP
sed -i -- 's/option domain-name "example.org";/#option domain-name "example.org";/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/#authoritative;/authoritative;/g' /etc/dhcp/dhcpd.conf
sed -i -- "s/INTERFACES=\"\"/INTERFACES=\"${apIface}\"/g" /etc/default/isc-dhcp-server

cat >> /etc/dhcp/dhcpd.conf <<EOF

subnet $ip1.$ip2.$ip3.0 netmask 255.255.255.0 {
	range $ip1.$ip2.$ip3.50 $ip1.$ip2.$ip3.100;
	option broadcast-address $ip1.$ip2.$ip3.255;
	option routers $apIp;
	default-lease-time 600;
	max-lease-time 7200;
	option domain-name "local";
	option domain-name-servers 8.8.8.8, 8.8.4.4;
}
EOF

sudo service isc-dhcp-server restart
