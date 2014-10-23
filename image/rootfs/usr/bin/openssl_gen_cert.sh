#!/bin/sh

KEYFILE=/home/root/privatekey.pem
CERTFILE=/home/root/certificate.pem

OPENSSL=/usr/bin/openssl
CERGEN=/usr/bin/Certificate_gen

echo -e "\nGenerating Self Signed Certificate"

if [ -s $CERTFILE ]
then
	echo "Removing existing certificate file"
	rm $CERTFILE
fi

if [ ! -r $CERTFILE ]
then
	echo "Creating certificate (${CERTFILE})"
	$CERGEN
else
	echo -e "\n## Certificate already exists."
	echo -e "## Delete ${CERTFILE} first and then run this script again to create a fresh certificate.\n"
	echo -e "## Or run the Certificate Info routine to view the existing certificate.\n"
	exit 1
fi

cat $KEYFILE
echo
cat $CERTFILE

