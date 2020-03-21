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

#SymbiYosys
#https://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing
git clone https://github.com/YosysHQ/SymbiYosys.git SymbiYosys
cd SymbiYosys
sudo make install


#Yices 2
git clone https://github.com/SRI-CSL/yices2.git yices2
cd yices2
autoconf
./configure
make -j$(nproc)
sudo make install

#Z3
git clone https://github.com/Z3Prover/z3.git z3
cd z3
python scripts/mk_make.py
cd build
make -j$(nproc)
sudo make install

#Super Prove
#https://bitbucket.org/sterin/super_prove_build/src/default/
#https://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing
hg clone https://bitbucket.org/sterin/super_prove_build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ..
ninja
ninja package
tar zxvf *.tar.gz
sudo mv super_prove /usr/local/
echo "#!/bin/bash
tool=super_prove; if [ "$1" != "${1#+}" ]; then tool="${1#+}"; shift; fi
exec /usr/local/super_prove/bin/${tool}.sh "$@"
" > /usr/local/bin/suprove

#Avy
git clone https://bitbucket.org/arieg/extavy.git
cd extavy
git submodule update --init
mkdir build; cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo cp avy/src/{avy,avybmc} /usr/local/bin/
#Note: before make -j#, I had to apply the patch file avy.patch
#This fixed errors regarding boost::bool and bool

#Boolector
git clone https://github.com/boolector/boolector
cd boolector
./contrib/setup-btor2tools.sh
./contrib/setup-lingeling.sh
./configure.sh
make -C build -j$(nproc)
sudo cp build/bin/{boolector,btor*} /usr/local/bin/
sudo cp deps/btor2tools/bin/btorsim /usr/local/bin/

#wavedrom
open https://github.com/wavedrom/wavedrom.github.io/releases/latest
