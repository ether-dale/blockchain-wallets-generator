# blockchain-wallets-generator
Safety creation keys for different blockchains. Always offline and minimum dependency.

```
sudo docker pull ubuntu
sudo docker run -it ubuntu
```

### requires
``` 
apt-get update
apt-get install -y git
apt-get install -y build-essential
apt-get install -y pwgen
apt-get install -y vim
apt-get install -y dc
./install.sh
```

## Etherium wallet generator
`./gen_eth_wallet.sh <wallet-name>`

## Tron wallet generator
`./gen_tron_wallet.sh <wallet-name>`