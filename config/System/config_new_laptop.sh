#!/bin/bash

# Disable touchscreen - https://ubuntuforums.org/showthread.php?t=2209083&highlight=disable+touchscreen

grep -r touchscreen /usr/share/X11/xorg.conf.d/10-evdev.conf

Section "InputClass"
Identifier "evdev touchscreen catchall"
MatchIsTouchscreen "on"
MatchDevicePath "/dev/input/event*"
Driver "evdev"
Option "Ignore" "on"
EndSection


#Disable nouveau drivers for Nvidia drivers to work
if [ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]; then
	echo "File 'blacklist-nouveau.conf' not found!"
	

	cat >> /etc/modprobe.d/blacklist-nouveau.conf <<EOF

	blacklist nouveau
	blacklist lbm-nouveau
	options nouveau modeset=0
	alias nouveau off
	alias lbm-nouveau off

	EOF

fi

sudo update-initramfs -u


