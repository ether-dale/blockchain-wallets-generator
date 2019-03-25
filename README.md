# blockchain-wallets-generator
Safety creation keys for different blockchains. Always offline and minimum dependency.

```
docker pull ubuntu
docker run -it ubuntu
```

## Install
```
apt-get update
apt-get install git                 - install git
git clone https://github.com/ether-dale/blockchain-wallets-generator.git
cd blockchain-wallets-generator
./install.sh
```
or in manual mode
```
apt-get update
apt-get install git                 - install git
apt-get install -y build-essential  - insall gcc and g++ compilers
apt-get install -y pwgen            - install password generator
apt-get install -y dc               - calculator
apt-get install -y vim-common       - xxd command 
apt-get install -y libssl-dev       - install openssl headers

git clone https://github.com/ether-dale/blockchain-wallets-generator.git
cd blockchain-wallets-generator

git clone https://github.com/maandree/libkeccak
cd libkeccak
make
make install PREFIX=/usr
cd ..
ln -s /usr/local/lib/libkeccak.so.1 /lib64/

git clone https://github.com/maandree/sha3sum
cd sha3sum
make
make install
cd ..

gcc src/eos/pubkey.cpp -o eosutils -lcrypto
```

## Usage
### Etherium wallet generator
`./gen_eth_wallet.sh <wallet-name>`
<br/><i>wallet-name</i> - directory name in eth-wallets folder which will contain generated keys.

### EOS wallet generator
`./gen_eos_wallet.sh <wallet-name> [seed]`
<br/><i>wallet-name</i> - directory name in eos-wallets folder which will contain generated keys
<br/><i>seed</i> - optional secret word that can help recover lost keys.
If <i>seed</i> does not pass the seed will be generated automatically and stored in `eos-wallet/wallet-name/wallet-name-pass`.


### Tron wallet generator
`./gen_tron_wallet.sh <wallet-name>`
<br/><i>wallet-name</i> -  directory name in tron-wallets folder which will contain generated keys
