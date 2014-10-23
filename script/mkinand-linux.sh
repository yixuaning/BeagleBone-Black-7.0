#!/bin/bash

PROGNAME=${0##*/}
[ ${PROGNAME/inand/} != $PROGNAME ] && INAND=1
DEVEX="/dev/sdc" && [ ! -z $INAND ] && DEVEX="/dev/mmcblk1"

cat << EOF

Transfer U-Boot & Linux to target device

EOF

if [[ -z $1 ]]; then
cat << EOF
SYNOPSIS:
    $PROGNAME {device node}

EXAMPLE:
    $0 $DEVEX

EOF
    exit 1
fi

[ ! -e $1 ] && echo "Device $1 not found" && exit 1

echo "All data on "$1" now will be destroyed! Continue? [y/n]"
read ans
if [ $ans != 'y' ]; then exit 1; fi

echo 0 > /proc/sys/kernel/printk

echo "[Unmounting all existing partitions on the device ]"

umount $1* &> /dev/null

echo "[Partitioning $1...]"

DRIVE=$1
## Clear partition table
dd if=/dev/zero of=$DRIVE bs=512 count=2 conv=fsync &>/dev/null

#partition
echo "partition start"
tmp=partitionfile
cs=$(fdisk -l ${DRIVE}| sed -n '4p'| cut -d ' ' -f 3)
if [ $cs == "cylinders" ];then
	echo u > $tmp
	echo n>> $tmp
else
	echo n > $tmp
fi

echo d >> $tmp
echo 1 >> $tmp
echo d >> $tmp
echo 2 >> $tmp
echo n >> $tmp
echo p >> $tmp
echo 1 >> $tmp
echo "" >> $tmp
echo +64M >> $tmp
echo n >> $tmp
echo p >> $tmp
echo 2 >> $tmp
echo "" >> $tmp
echo "" >> $tmp
echo t >> $tmp
echo 1 >> $tmp
echo c >> $tmp
echo a >> $tmp
echo 1 >> $tmp
echo w >> $tmp
fdisk ${DRIVE} < $tmp &> /dev/null
sync
rm $tmp
echo "partition done"

mkfs.vfat -F 32 -n "boot" ${DRIVE}p1
sync
mkfs.ext3 -L "rootfs" ${DRIVE}p2
sync


if [ -x /sbin/partprobe ]; then
    /sbin/partprobe ${DRIVE} &> /dev/null
else
    sleep 1
fi

unset DPART
DPART=`ls -1 ${DRIVE}1 2> /dev/null`
[ -z $DPART ] && DPART=`ls -1 ${DRIVE}p1 2> /dev/null`
[ -z $DPART ] && echo "$DRIVE's partition 1 not found" && exit 1

if ! mount $DPART /mnt/cf &> /dev/null; then
    echo  "Cannot mount $DPART"
    exit 1
fi

echo "[Copy u-boot.img]"
cp ../image/u-boot.img /mnt/

echo "[Copy uImage]"
cp ../image/uImage /mnt/

umount $DPART

DPART=`ls -1 ${DRIVE}2 2> /dev/null`
[ -z $DPART ] && DPART=`ls -1 ${DRIVE}p2 2> /dev/null`
[ -z $DPART ] && echo "$DRIVE's partition 2 not found" && exit 1

echo "[Copying rootfs...]"
if ! mount $DPART /mnt/ &> /dev/null; then
    echo  "Cannot mount $DPART"
    exit 1
fi

rmdir /mnt/lost+found/
cp -a ../image/rootfs/* /mnt/ &> /dev/null

chown -R 0.0 /mnt/*
sync
umount $DPART

echo 7 > /proc/sys/kernel/printk
echo "[Done]"
