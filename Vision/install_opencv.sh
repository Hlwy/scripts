#!/bin/bash

# Install OpenCV from source
cd ~/Libraries
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.1.zip
unzip opencv.zip

# Install Additional OpenCV modules from source
# wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.1.zip
# unzip opencv_contrib.zip

# Compile OpenCV
cd ~/Libraries/opencv-3.3.1/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D BUILD_EXAMPLES=ON ..

# Wait for user to review the cmake config before continuing
read -p "Review CMake configuration: Press Enter when ready to continue...."

make -j4
sudo make install

rm ~/Libraries/opencv.zip
