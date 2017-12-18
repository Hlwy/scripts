#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

sudo apt install isc-dhcp-server

# Ask for user-customized interface name
read -s -p "Enter Interface for the Access Point: "  apIface
echo "Access Point Interface: $apIface"

read -p "Enter Static IP address assigned to Access Point: "  apIp
echo "Access Point IP: $apIp"

# Break down user-inputted IP address to 4 parts for dhcp customization later on in script
ip1="$(echo $apIp | cut -d '.' -f 1)"
ip2="$(echo $apIp | cut -d '.' -f 2)"
ip3="$(echo $apIp | cut -d '.' -f 3)"
ip4="$(echo $apIp | cut -d '.' -f 4)"
echo "Test Grab: $ip1 $ip2 $ip3 $ip4"

# Create hostapd.conf backup
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup

## Configure DHCP
sed -i -- 's/option domain-name "example.org";/#option domain-name "example.org";/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/#authoritative;/authoritative;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/INTERFACES=""/INTERFACES="$apIface"/g' /etc/default/isc-dhcp-server.conf

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
