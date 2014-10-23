#!/bin/bash

. echo_color.sh
[ ! "${CC_PATH}" ] && echo_red "Please run script 'setenv.sh' to setup environment variables" && exit 1

echo_light_blue "Build U-Boot on the ${UBOOT_SOURCE}"

CURR=${PWD}
cd ${UBOOT_SOURCE}
make am335x_evm_config
make -j8

cp -a ${UBOOT_SOURCE}/MLO ${SRCROOT}/image/
cp -a ${UBOOT_SOURCE}/u-boot.img ${SRCROOT}/image/
cd ${CURR}

echo_light_blue "Build U-Boot and drivers Done."
