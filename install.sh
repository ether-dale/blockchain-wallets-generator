#!/usr/bin/env bash

apt-get install -y build-essential &&
apt-get install -y pwgen &&
apt-get install -y dc &&
apt-get install -y vim-common &&
apt-get install -y libssl-dev &&

cd ..
git clone https://github.com/maandree/libkeccak
cd libkeccak
make
make install PREFIX=/usr
cd ..
ln -s /usr/local/lib/libkeccak.so.1 /lib64/

git clone https://github.com/maandree/sha3sum
cd sha3sumcd
make
make install
cd ..

cd blockchain-wallets-generator
gcc src/eos/pubkey.cpp -o eosutils -lcrypto







