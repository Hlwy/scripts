#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

systemctl stop dnsmasq
systemctl stop hostapd

## Read in user defined inputs
read -p "Enter Name for Access Point: "  nameAp
echo "Access Point Name: $nameAp"

read -p "Enter Static IP address (using 192.168.1.XX) to be assigned to Access Point: "  ipAp
echo "Access Point IP: $ipAp"

read -s -p "Enter password for Access Point: "  pwdAp

# Disable wifi interface from being hndled by DHCP
cat > /etc/dhcpcd.conf <<EOF
## Added by setup_wifi_ap.sh script ####
denyinterfaces wlan1
EOF

cat >> /etc/network/interfaces <<EOF

## Added by setup_wifi_ap.sh script ####
allow-hotplug wlan1
iface wlan1 inet static
	address $ipAp
	netmask 255.255.255.0
	network 192.168.1.0

EOF

# Restart dhcp daemon and setup new interface configuration
service dhcpcd restart
ifdown wlan1
ifup wlan1

## Configure DHCP server (dnsmasq)
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

cat > /etc/dnsmasq.conf <<EOF
interface=wlan1
usually wlan1
     dhcp-range=192.168.1.2,192.168.1.50,255.255.255.0,24h
EOF


service hostapd start
service dnsmasq start

# Finalize setup (reboot ready)
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable
