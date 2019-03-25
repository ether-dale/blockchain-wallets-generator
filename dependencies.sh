#!/usr/bin/env bash
apt-get update
apt-get install -y build-essential  - insall gcc and g++ compilers
apt-get install -y pwgen            - install password generator
apt-get install -y dc               - calculator
apt-get install -y vim-common       - xxd command
apt-get install -y libssl-dev       - install openssl headers

./install.sh