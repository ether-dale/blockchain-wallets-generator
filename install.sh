#!/usr/bin/env bash

git clone https://github.com/maandree/libkeccak
cd libkeccak
make
sudo make install PREFIX=/usr
cd
sudo ln -s /usr/local/lib/libkeccak.so.1 /lib64/

git clone https://github.com/maandree/sha3sum
cd sha3sum
make
sudo make install