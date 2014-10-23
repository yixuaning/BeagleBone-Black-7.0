#!/bin/sh

CERTFILE=/home/root/certificate.pem

OPENSSL=/usr/bin/openssl

CERINFO=/usr/bin/Certificate_info
CERGEN=/usr/bin/Certificate_gen

echo -e "\nDisplay Certificate Information"

if [ ! -r $CERTFILE ]
then
	echo "Certificate does not exist.  Generating new certificate before starting server..."
	$CERGEN
fi

$CERINFO

