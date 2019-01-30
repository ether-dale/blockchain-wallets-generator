# blockchain-wallets-generator
Safety creation keys for different blockchains. Always offline and minimum dependency.

```
docker pull fedora
docker run -it fedora
```

### requires
``` 
$ dnf -y update`
$ dnf -y install git`
```

`dnf install automake make gcc-c++ git gmp-devel kernel-devel`

```
git clone https://github.com/maandree/libkeccak
cd libkeccak
make
sudo make install PREFIX=/usr 
cd
sudo ln -s /usr/local/lib/libkeccak.so.1 /lib64/`
```
```
git clone https://github.com/maandree/sha3sum
cd sha3sum
make
sudo make install
cd
```


## Etherium wallet generator
`./gen_eth_wallet.sh <wallet-name>`

## Tron wallet generator
`./gen_tron_wallet.sh <wallet-name>`