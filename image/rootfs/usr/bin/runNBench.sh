#!/bin/sh

# NBench needs to be run in the same directory as the NNET.DAT file
cd /usr/bin
if [ ! -e "NNET.DAT" ]
then
    echo "Could not find NNET.DAT file.  Not running NBench"
    exit 1
fi

echo "Starting nbench.  This will take several minutes to execute and"
echo "Then the results will be displayed"
/usr/bin/nbench
