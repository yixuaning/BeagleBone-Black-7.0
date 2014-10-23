#!/bin/sh

OPENSSL=/usr/bin/openssl

cat /proc/cpuinfo | grep OMAP3 > /dev/null 2> /dev/null
if [ `echo $?` = "0" ]
then
	export CPU=OMAP3
else
	export CPU=other
fi

if [ -r $OPENSSL ]
then
	$OPENSSL version
else
	echo "Unable to find OpenSSL"
	exit 1
fi

echo "################################"
echo "Running OpenSSL Speed tests.  "
echo "There are 7 tests and each takes 15 seconds..."
echo

TEMP=/home/root/temp

echo "Running aes-128-cbc test.  Please Wait..."
time -v $OPENSSL speed -evp aes-128-cbc -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running aes-192-cbc test.  Please Wait..."
time -v $OPENSSL speed -evp aes-192-cbc -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running aes-256-cbc test.  Please Wait..."
time -v $OPENSSL speed -evp aes-256-cbc -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running des-cbc test.  Please Wait..."
time -v $OPENSSL speed -evp des-cbc -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running des3 test.  Please Wait..."
time -v $OPENSSL speed -evp des3 -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running sha1 test.  Please Wait..."
time -v $OPENSSL speed -evp sha1 -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

echo "Running md5 test.  Please Wait..."
time -v $OPENSSL speed -evp md5 -engine cryptodev > $TEMP 2>&1
egrep 'Doing|User|System|Percent|Elapsed' $TEMP

rm $TEMP
