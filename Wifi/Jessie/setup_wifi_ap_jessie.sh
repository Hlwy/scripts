#!/bin/bash

# Check for sudo permissions
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

# Look for help sign
if [ "$1" == "-h" ]; then
  echo "Usage: $0 '$ip $ssid $interface'"
  exit 0
fi

# check for required argument (assigned static IP address)
if [[ $# -lt 1 ]];
	then echo "You need to pass a static IP address to assign to your access point!"
	echo "Usage:"
	echo "sudo $0 desired_ip desired_ssid [AP_interface]"
	exit
fi

# check for required argument (assigned AP SSID)
if [[ $# -lt 2 ]];
	then echo "You need to pass a SSID name to assign to your access point!"
	echo "Usage:"
	echo "sudo $0 desired_ip desired_ssid [AP_interface]"
	exit
fi

# Store arguments for later usage
apIp="$1"
apName="$2"
apIface="wlan1"

# check for optional argument (assigned interface for AP)
if [[ $# -eq 3 ]]; then
	apIface=$3
fi

## Echo Inputs for debugging
echo "Access Point IP: $apIp"
echo "Access Point Name: $apName"
echo "Access Point Interface: $apIface"

# Install TP-Link Wifi Dongle Driver
sh ./install_rtl8188_driver.sh

# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Install System dependencies
sudo apt update
sudo apt-get install -y hostapd isc-dhcp-server

# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Install modified hostapd binary (Thanks to jenssegers)
sudo ./install_jenssegers_hostapd.sh
# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Configure DHCP
sudo ./config_dhcp.sh $apIp $apIface
# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Configure Interfaces
sudo ./config_network_interfaces.sh $apIp $apIface
# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Configure Hostapd config
sudo ./config_hostapd.sh $apName $apIface
# Wait till user feels okay continuing
read -p "Press Enter when ready to continue...."

# Configure IP Routing
sed -i -- 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
