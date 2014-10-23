#!/bin/sh

KEYFILE=/home/root/privatekey.pem
PUBKEY=/home/root/pubkey.pem

OPENSSL=/usr/bin/openssl
CERGEN=/usr/bin/Certificate_gen
PUBKEYGEN=/usr/bin/Gen_publickey

echo -e "\nGenerating Public Key from ${KEYFILE}"

if [ ! -r $KEYFILE ]
then
	echo "Private Key does not exist.  Generate certificate before generating a public key"
	$CERGEN
fi

$PUBKEYGEN
echo -e "\nPublic Key written to ${PUBKEY}\n"





