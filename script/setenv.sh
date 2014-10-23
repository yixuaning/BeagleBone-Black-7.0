#!/bin/bash
export SRCROOT=${PWD}/..
export CC_PATH=${SRCROOT}/linux-devkit/sysroots/i686-arago-linux/usr
export CROSS_COMPILE=${CC_PATH}/bin/arm-linux-gnueabihf-
export CC=${CROSS_COMPILE}gcc
export ARCH=arm
export KROOT=${SRCROOT}/board-support/linux-3.12.10-ti2013.12.01
export UBOOT_SOURCE=${SRCROOT}/board-support/u-boot-2013.10-ti2013.12.01
export ROOTFS=${SRCROOT}/image/rootfs
export PATH=${CC_PATH}/bin:${UBOOT_SOURCE}/tools:$PATH
rm -rf ${LOG}
