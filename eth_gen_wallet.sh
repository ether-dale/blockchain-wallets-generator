#!/usr/bin/env bash
#
#Copyright (c) 2019 Ether Dale
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

WALLET=$1

if [[ -z ${WALLET} ]]
then
 echo "Generate wallet: not enough arguments"
 echo ""
 echo "Usage:"
 echo "./eth_gen_wallet.sh <wallet-name>"
 exit 1;
fi

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR=${ROOT}/eth-wallets/${WALLET}

if [[ -d ${DIR} ]]
then
 echo "Error: wallet name already exists"
 exit 1;
else
  if [[ ! -d "${ROOT}/eth-wallets" ]]
  then
    mkdir ${ROOT}/eth-wallets
  fi
 mkdir ${DIR}
fi

#echo "Generate password for wallet"
#pwgen -s 13 7 > ${DIR}/${WALLET}-pass

#echo "Generate the private and public keys"
openssl ecparam -name secp256k1 -genkey -noout | openssl ec -text -noout > ${DIR}/${WALLET}-key

#echo "Extract the public key and remove the EC prefix 0x04"
cat ${DIR}/${WALLET}-key | grep pub -A 5 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^04//' > ${DIR}/${WALLET}-pub

#echo "Extract the private key and remove the leading zero byte"
cat ${DIR}/${WALLET}-key | grep priv -A 3 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^00//' > ${DIR}/${WALLET}-priv

#echo "Generate the hash and take the address part"
cat ${DIR}/${WALLET}-pub | keccak-256sum -x -l | tr -d ' -' | tail -c 41 > ${DIR}/${WALLET}-address

rm ${DIR}/${WALLET}-key
rm ${DIR}/${WALLET}-pub

echo "Keys has been generated successfully and stored in ${DIR}"
