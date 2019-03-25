# blockchain-wallets-generator
Safety creation keys for different blockchains. Always offline and minimum dependency.

```
sudo docker pull ubuntu
sudo docker run -it ubuntu
```

## Install
```
apt-get update
cd apt-get install git              - install git
```

```
git clone https://github.com/ether-dale/blockchain-wallets-generator.git
cd blockchain-wallets-generator
./install.sh
```
or
```
apt-get install -y build-essential  - insall gcc and g++ compilers
apt-get install -y pwgen            - install password generator
apt-get install -y dc               - calculator
apt-get install -y vim-common       - xxd command 
apt-get install -y libssl-dev       - install openssl headers

git clone https://github.com/ether-dale/blockchain-wallets-generator.git
cd blockchain-wallets-generator
./install.sh
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

gcc src/eos/pubkey.cpp -o eosutils -lcrypto
```

## Usage
### Etherium wallet generator
`./gen_eth_wallet.sh <wallet-name>`

### EOS wallet generator
`./gen_eos_wallet.sh <wallet-name> [seed]`

### Tron wallet generator
`./gen_tron_wallet.sh <wallet-name>`