#!/bin/bash

# Change to default network interface names - http://www.itzgeek.com/how-tos/mini-howtos/change-default-network-name-ens33-to-old-eth0-on-ubuntu-16-04.html
sed -i -- 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
#sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo update-grub

# Disable touchscreen - https://ubuntuforums.org/showthread.php?t=2209083&highlight=disable+touchscreen

