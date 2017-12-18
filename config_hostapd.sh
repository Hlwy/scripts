#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

## Read in user defined inputs
read -p "Enter Name for Access Point: "  apName
# echo "Access Point Name: $apName"

read -p "Enter Interface for the Access Point: "  apIface
# echo "Access Point Interface: $apIface"

# Create hostapd.conf backup
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.backup

# Modify Config files
sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat > /etc/hostapd/hostapd.conf <<EOF
interface=$apIface
ssid=$apName
driver=rtl871xdrv
ieee80211n=1
hw_mode=g
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
channel=7
EOF


# Reload hostapd
sudo systemctl daemon-reload
sudo service hostapd restart
