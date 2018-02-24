
#!/bin/bash

#run this script as root

ip=$1
iface=$2

#if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9] ]]; then
#  echo "success"
#else
#  echo "invalid ip address"
#  exit 1
#fi

echo "##############" > /etc/network/interfaces
echo "auto $2" >> /etc/network/interfaces 
echo "iface $2 inet static" >> /etc/network/interfaces  
echo "address $ip" >> /etc/network/interfaces   
echo "gateway 192.168.1.1" >> /etc/network/interfaces
echo "network 192.168.1.0" >> /etc/network/interfaces  
echo "broadcast 192.168.1.255" >> /etc/network/interfaces
echo "dns-nameservers 8.8.8.8 66.212.48.10" >> /etc/network/interfaces  
