#!/usr/bin/env bash

apt-get install -y build-essential pwgen dc vim-common libssl-dev

git clone https://github.com/maandree/libkeccak
cd libkeccak
make
make install PREFIX=/usr
ln -s /usr/local/lib/libkeccak.so.1 /lib64/
cd ..

git clone https://github.com/maandree/sha3sum
cd sha3sum
make
make install
cd ..

gcc src/eos/pubkey.cpp -o utils-eos -lcrypto







