#!/bin/bash
read -n1 -p "Do you need to install GTSAM toolbox and its dependencies? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then

     echo
     echo "Checking for GTSAM Dependencies..."
     echo

     # CMake
     PKG_I="cmake"
     PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PKG_I|grep "install ok installed")
     echo "    Checking for $PKG_I: $PKG_OK"
     if [ "" == "$PKG_OK" ]; then
          echo "    No $PKG_I. Installing $PKG_I..."
          echo
          sudo apt-get --force-yes --yes install $PKG_I
     fi

     # TBB
     PKG_I="libtbb-dev"
     PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PKG_I|grep "install ok installed")
     echo "    Checking for $PKG_I: $PKG_OK"
     if [ "" == "$PKG_OK" ]; then
          echo "    No $PKG_I. Installing $PKG_I..."
          echo
          sudo apt-get --force-yes --yes install $PKG_I
     fi

     # Boost
     PKG_I="libboost-all-dev"
     PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PKG_I|grep "install ok installed")
     echo "    Checking for $PKG_I: $PKG_OK"
     if [ "" == "$PKG_OK" ]; then
          echo "    No $PKG_I. Installing $PKG_I..."
          echo
          sudo apt-get --force-yes --yes install $PKG_I
     fi

     echo
     echo "Installing GTSAM..."
     echo

     echo Please type in your git or bitbucket username.
     read username

     mkdir ~/Libraries
     cd ~/Libraries
     git clone https://$username@bitbucket.org/gtborg/gtsam.git
     cd gtsam
     mkdir build
     cd build
     cmake ..
     make check
     sudo make install
fi
echo
echo "GTSAM Installed"
echo

# # Intel Math Kernel Library (MKL)
# wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12725/l_mkl_2018.2.199.tgz
# # Intel Threading Building Blocks (TBB)
# wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12498/l_tbb_2018.2.199.tgz

# libtbb-dev
# libboost-all-dev
