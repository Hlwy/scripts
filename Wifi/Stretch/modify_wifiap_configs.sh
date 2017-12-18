#!/bin/bash

## Read in user defined inputs
read -p "Enter Name for Access Point: "  apName
echo "Access Point Name: $apName"

read -p "Enter Static IP address (using 192.168.1.XX) to be assigned to Access Point: "  apIp
echo "Access Point IP: $apIp"

read -s -p "Enter Interface for the Access Point: "  apIface
echo "Access Point Interface: $apIface"



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

## Configure DHCP
sed -i -- 's/option domain-name "example.org";/#option domain-name "example.org";/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/#authoritative;/authoritative;/g' /etc/dhcp/dhcpd.conf
sed -i -- 's/INTERFACES=""/INTERFACES="$apIface"/g' /etc/default/isc-dhcp-server.conf

cat >> /etc/dhcp/dhcpd.conf <<EOF

subnet 192.168.2.0 netmask 255.255.255.0 {
range 192.168.2.10 192.168.2.50;
option broadcast-address 192.168.2.255;
option routers $apIp;
default-lease-time 600;
max-lease-time 7200;
option domain-name "local";
option domain-name-servers 8.8.8.8, 8.8.4.4;
}
EOF

sudo service isc-dhcp-server restart

## Configure hostapd
sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat > /etc/hostapd/hostapd.conf <<EOF
interface=$apIface
ssid=$apName
driver=rtl871xdrv
hw_mode=g
wmm_enabled=0
macaddr_acl=0
ignore_broadcast_ssid=0
channel=7
auth_algs=1
EOF

# mv /usr/sbin/hostapd /usr/sbin/hostapd.bak
# mv hostapd /usr/sbin/hostapd
# chmod 755 /usr/sbin/hostapd

# Configure IP Routing
sed -i -- 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

cat > /etc/network/interfaces <<EOF

pre-up iptables-restore < /etc/iptables.ipv4.nat
EOF
