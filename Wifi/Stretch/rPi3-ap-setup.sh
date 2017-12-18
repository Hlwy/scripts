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

apt-get remove --purge hostapd -y
apt-get install hostapd dnsmasq -y

cat > /etc/systemd/system/hostapd.service <<EOF
[Unit]
Description=Hostapd IEEE 802.11 Access Point
After=sys-subsystem-net-devices-wlan0.device
BindsTo=sys-subsystem-net-devices-wlan0.device

[Service]
Type=forking
PIDFile=/var/run/hostapd.pid
ExecStart=/usr/sbin/hostapd -B /etc/hostapd/hostapd.conf -P /var/run/hostapd.pid

[Install]
WantedBy=multi-user.target

EOF

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h
EOF

cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
hw_mode=g
channel=10
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_passphrase=$APPASS
ssid=$APSSID
EOF

sed -i -- 's/allow-hotplug wlan0//g' /etc/network/interfaces
sed -i -- 's/iface wlan0 inet manual//g' /etc/network/interfaces
sed -i -- 's/    wpa-conf \/etc\/wpa_supplicant\/wpa_supplicant.conf//g' /etc/network/interfaces

cat >> /etc/network/interfaces <<EOF
	wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

# Added by rPi Access Point Setup
allow-hotplug wlan0
iface wlan0 inet static
	address 10.0.0.1
	netmask 255.255.255.0
	network 10.0.0.0
	broadcast 10.0.0.255

EOF

echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf

systemctl enable hostapd

echo "All done! Please reboot"
