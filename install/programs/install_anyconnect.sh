#!/bin/bash

# AnyConnect VPN (for Matlab)
sudo apt-get install openconnect network-manager-openconnect-gnome
sudo ./anyconnect/anyconnect-4.3.05017/vpn/vpn_installer.sh

# Enter in "Connect To: " -> vpn.cites.illinois.edu
# Enter in "Group Menu: " -> SplitTunnel
# Enter in "Username: "   -> NetId
# Enter in "Password: "   -> AD Password
