#!/bin/bash

AMIROOT=`whoami | awk {'print $1'}`
if [ "$AMIROOT" != "root" ] ; then

	echo "	**** Error *** must run script with sudo"
	echo ""
	exit
fi

PROGNAME=${0##*/}
[ ${PROGNAME/inand/} != $PROGNAME ] && INAND=1
DEVEX="/dev/sdc" && [ ! -z $INAND ] && DEVEX="/dev/mmcblk0"

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

DISK=$1
## Clear partition table
dd if=/dev/zero of=$DISK bs=1M count=20 &>/dev/null

## Create partition table
SIZE=`fdisk -l $DISK | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

sfdisk -D -H 255 -S 63 -C $CYLINDERS $DISK << EOF
,9,0x0C,*
10,,,-
EOF

sudo mkfs.vfat -F 32 ${DISK}1 -n BOOT
sudo mkfs.ext3 ${DISK}2 -L rootfs
sync

mkdir -p /media/boot/
mkdir -p /media/rootfs/

sudo mount ${DISK}1 /media/boot/
sudo mount ${DISK}2 /media/rootfs/

echo "[Copy u-boot.img]"
cp -v ../image/MLO		/media/boot/
cp -v ../image/u-boot.img	/media/boot/
cp -v ../image/uEnv.txt		/media/boot/

echo "[Copying rootfs...]"
cp -ard ../image/rootfs/* /media/rootfs/

rmdir /media/rootfs/lost+found/


sync
umount ${DISK}*

rmdir /media/boot
rmdir /media/rootfs

echo 7 > /proc/sys/kernel/printk
echo "[Done]"
