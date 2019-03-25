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
SEED=$2

if [[ -z ${WALLET} ]]
then
 echo "Generate wallet: not enough arguments"
 echo ""
 echo "Usage:"
 echo "./eos_gen_wallet.sh <wallet-name> [seed]"
 exit 1;
fi

ROOT=${PWD}
PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR=${ROOT}/eos-wallets/${WALLET}


if [[ ! -f ${PROJECT_PATH}/utils.sh ]]
then
 echo "Error: utils.sh file not found."
 exit 1;
fi

if [[ ! -f ${PROJECT_PATH}/utils-eos ]]
then
 echo "Error: utils-eos file not found."
 echo "Try to run ./install.sh"
 exit 1;
fi


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


if [[ -z ${SEED} ]]
then
    #echo "Generate password for wallet"
    SEED=$(pwgen -s 13 7)
    echo ${SEED}> ${DIR}/${WALLET}-seed
fi

HASH="80$( echo -n ${SEED} | sha256sum | tr -d ' -' )"

#echo "HASH: "${HASH}
SHA256_0=$( echo -n ${HASH} | xxd -r -p | sha256sum | tr -d ' -' )
#echo "sha256_0: "${SHA256_0}

SHA256_1=$( echo -n ${SHA256_0} | xxd -r -p | sha256sum | tr -d ' -' )
#echo "sha256_1: "${SHA256_1}

CHECKSUM=$( echo -n ${SHA256_1} | cut -c1-8 )
#echo ">>> "${HASH}
ADDCHECKSUM=${HASH}${CHECKSUM}

source ${PROJECT_PATH}/utils.sh
#echo "An encoded mainnet address begins with T and is 34 bytes in length."
PRIVATEKEY=$(encodeBase58 ${ADDCHECKSUM})

#echo "private key: "${PRIVATEKEY}
echo ${PRIVATEKEY} > ${DIR}/${WALLET}-private

ENCODED_PUB=$(echo -n $(${PROJECT_PATH}/utils-eos ${HASH}))

CHECKSUM=$(echo -n ${ENCODED_PUB} | xxd -p -r | openssl dgst -ripemd160 | cut -c10-17)

ADDCHECKSUM=${ENCODED_PUB}${CHECKSUM}

source ${PROJECT_PATH}/utils.sh
#echo "An encoded mainnet address begins with T and is 34 bytes in length."
BASE58=$(encodeBase58 ${ADDCHECKSUM})

PUBLICKEY="EOS${BASE58}"
echo ${PUBLICKEY} > ${DIR}/${WALLET}-public

echo "Keys has been generated successfully and stored in ${DIR}"







