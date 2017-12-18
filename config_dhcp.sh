#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

# Ask for user-customized interface name
read -s -p "Enter Interface for the Access Point: "  apIface
echo "Access Point Interface: $apIface"

read -p "Enter Static IP address channel (i.e XXX.XXX.some-number.XXX) of Access Point: "  apSubChan
echo "Access Point IP: $apSubChan"

read -p "Enter Static IP address end point (i.e XXX.XXX.X.some-number) of Access Point: "  apEndIp
echo "Access Point IP: $apEndIp"

# Create hostapd.conf backup
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup

## Configure DHCP
sed -i -- 's/option domain-name "example.org";/#option domain-name "example.org";/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/#authoritative;/authoritative;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/INTERFACES=""/INTERFACES="$apIface"/g' /etc/default/isc-dhcp-server.conf

cat >> /etc/dhcp/dhcpd.conf <<EOF

subnet 192.168.$apSubChan.0 netmask 255.255.255.0 {
range 192.168.$apSubChan.50 192.168.$apSubChan.100;
option broadcast-address 192.168.$apSubChan.255;
option routers 192.168.$apSubChan.$apEndIp;
default-lease-time 600;
max-lease-time 7200;
option domain-name "local";
option domain-name-servers 8.8.8.8, 8.8.4.4;
}
EOF

sudo service isc-dhcp-server restart
