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

## Read in user defined inputs
# read -p "Enter Static IP address assigned to Access Point: "  apIp
# read -p "Enter Name for Access Point: "  apName
# read -p "Enter Interface for the Access Point: "  apIface



# # Disable wifi interface from being hndled by DHCP
# cat > /etc/dhcpcd.conf <<EOF
# ## Added by setup_wifi_ap.sh script ####
# denyinterfaces wlan1
# EOF
#
# cat >> /etc/network/interfaces <<EOF
#
# ## Added by setup_wifi_ap.sh script ####
# allow-hotplug wlan1
# iface wlan1 inet static
# 	address $ipAp
# 	netmask 255.255.255.0
# 	network 192.168.1.0
#
# EOF
#
# # Restart dhcp daemon and setup new interface configuration
# service dhcpcd restart
# ifdown wlan1
# ifup wlan1
#
# ## Configure DHCP server (dnsmasq)
# mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
#
# cat > /etc/dnsmasq.conf <<EOF
# interface=wlan1
# usually wlan1
#      dhcp-range=192.168.1.2,192.168.1.50,255.255.255.0,24h
# EOF
#
#
# service hostapd start
# service dnsmasq start
#
# # Finalize setup (reboot ready)
# sudo update-rc.d hostapd enable
# sudo update-rc.d isc-dhcp-server enable
