#!/bin/bash

# sudo apt-get install -y unzip wget
# wget https://github.com/opencv/opencv/archive/3.2.0.zip
# unzip 3.2.0.zip
# rm 3.2.0.zip
# mv opencv-3.2.0 OpenCV
# cd OpenCV
# mkdir build
# cd build
# cmake -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DENABLE_PRECOMPILED_HEADERS=OFF ..
# make -j4
# sudo make install
# sudo ldconfig


# Install OpenCV from source
cd ~/Libraries
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.0.0.zip
unzip opencv.zip
# wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.0.0.zip
# unzip opencv_contrib.zip

# Compile OpenCV
cd ~/opencv-3.0.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D BUILD_EXAMPLES=ON ..

make -j4
sudo make install

# Install OpenCV from source
cd ~/Libraries
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.1.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.1.zip
unzip opencv.zip
unzip opencv_contrib.zip

# Compile OpenCV
cd ~/opencv-3.3.1/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
     -D ENABLE_PRECOMPILED_HEADERS=OFF \
	-D BUILD_EXAMPLES=ON ..

make -j4
sudo make install
