#!/usr/bin/env bash

git clone https://github.com/maandree/libkeccak
cd libkeccak
make
make install PREFIX=/usr
cd
ln -s /usr/local/lib/libkeccak.so.1 /lib64/

git clone https://github.com/maandree/sha3sum
cd sha3sum
make
make install







