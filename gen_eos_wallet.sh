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
 echo " ./gen-wallet <wallet name>"
 exit 1;
fi

ROOT=${PWD}
DIR=${ROOT}/eos-wallets/${WALLET}

if [[ -d ${DIR} ]]
then
 echo "Error: wallet name already exists"
 exit 1;
else
  if [[ ! -d "${ROOT}/eos-wallets" ]]
  then
    mkdir ${ROOT}/eos-wallets
  fi
 mkdir ${DIR}
fi

#echo "Generate password for wallet"
SEED=$(pwgen -s 13 7)
echo ${SEED}> ${DIR}/${WALLET}-pass

HASH="80$( echo -n ${SEED} | sha256sum | tr -d ' -' )"

#echo "HASH: "${HASH}
SHA256_0=$( echo -n ${HASH} | xxd -r -p | sha256sum | tr -d ' -' )
#echo "sha256_0: "${SHA256_0}

SHA256_1=$( echo -n ${SHA256_0} | xxd -r -p | sha256sum | tr -d ' -' )
#echo "sha256_1: "${SHA256_1}

CHECKSUM=$( echo -n ${SHA256_1} | cut -c1-8 )
#echo ">>> "${HASH}
ADDCHECKSUM=${HASH}${CHECKSUM}

source ./utils.sh
#echo "An encoded mainnet address begins with T and is 34 bytes in length."
PRIVATEKEY=$(encodeBase58 ${ADDCHECKSUM})

echo "private key: "${PRIVATEKEY}
echo ${PRIVATEKEY} > ${DIR}/${WALLET}-private

./eosutils ${HASH}

while IFS='' read -r line || [[ -n "$line" ]]; do
    PUB=${line}
done < "${ROOT}/eos-wallets/encoded_pub"

CHECKSUM=$(echo -n ${PUB} | xxd -p -r | /usr/local/bin/openssl dgst -ripemd160 | cut -c10-17)

ADDCHECKSUM=${PUB}${CHECKSUM}

rm ${ROOT}/eos-wallets/encoded_pub

source ./utils.sh
#echo "An encoded mainnet address begins with T and is 34 bytes in length."
BASE58=$(encodeBase58 ${ADDCHECKSUM})

PUBLICKEY="EOS${BASE58}"
echo ${PUBLICKEY} > ${DIR}/${WALLET}-public
echo "public key: "${PUBLICKEY}







