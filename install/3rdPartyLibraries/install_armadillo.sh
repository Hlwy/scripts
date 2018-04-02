#!/bin/bash
read -n1 -p "Do you need to install Armadillo and its dependencies? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     echo
     echo "Installing Armadillo Dependencies..."
     echo
     sudo apt install -y liblapack-dev
     sudo apt install -y libblas-dev
     sudo apt install -y libboost-all-dev
     echo
     echo "Installing Armadillo..."
     echo
     sudo apt install -y libarmadillo-dev
fi
echo
echo "Armadillo Installed"
echo
