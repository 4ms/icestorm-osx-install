#!/bin/bash

mkdir ~/fpga
cd fpga
#
#icestorm
brew install libftdi0
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j4
sudo make install
cd ..
#
#arachne-pnr
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j4
sudo make install
cd ..
#
#nextpnr
brew install boost-python3
ln -s /usr/bin/python3 /usr/local/bin/python3
git clone https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local -DQt5_DIR=$(brew --prefix qt5)/lib/cmake/Qt5 .
make -j4




sudo make install
cd ..
#
#yosys
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make -j4
sudo make install

