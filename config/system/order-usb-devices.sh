#!/bin/bash


sleep $1 #try if this is needed, needs an increase etc

for i in /sys/bus/pci/drivers/[uoex]hci_hcd/*:*; do
  echo "${i##*/}" > "${i%/*}/unbind"
  echo "${i##*/}" > "${i%/*}/bind"
done

echo '1-1' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 1
echo '1-2' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 1
echo '3-9' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 1
echo '3-13' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 2
echo '3-1' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 2
echo '2-1' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 2
echo '2-2' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 1

echo '1-2' |sudo tee /sys/bus/usb/drivers/usb/bind # attach device 1
sleep 1
echo '1-1' |sudo tee /sys/bus/usb/drivers/usb/bind # attach device 1
sleep 1
echo '3-9' |sudo tee /sys/bus/usb/drivers/usb/bind # attach device 1
sleep 1
echo '3-13' |sudo tee /sys/bus/usb/drivers/usb/bind # attach device 2
sleep 1
echo '3-1' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 2
sleep 1
echo '2-1' |sudo tee /sys/bus/usb/drivers/usb/unbind # detach device 2
sleep 1
echo '2-2' |sudo tee /sys/bus/usb/drivers/usb/bind # attach device 1
