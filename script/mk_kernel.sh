#!/bin/bash

. echo_color.sh

[ ! "${CC_PATH}" ] && echo_red "Please run script 'setenv.sh' to setup environment variables" && exit 1

echo_light_blue "Build kernel and drivers on the ${KROOT}"

CURR=${PWD}
cd ${KROOT}
make omap2plus_defconfig
make -j8 uImage || ( exit 1 )
[ "$?" -ne 0 ] && echo_red "Build failure!" && exit 1
make -j8 am335x-boneblack.dtb || ( exit 1 )
[ "$?" -ne 0 ] && echo_red "Build failure!" && exit 1

make -j8 ${CROSS_CFG} modules  || ( exit 1 ) 
[ "$?" -ne 0 ] && echo_red "Build failure!" && exit 1

export INSTALL_MOD_PATH=${ROOTFS}
make -j8 modules_install 
 

cp -a ${KROOT}/arch/arm/boot/zImage ${ROOTFS}/boot
cp -a ${KROOT}/arch/arm/boot/dts/am335x-boneblack.dtb ${ROOTFS}/boot
cd ${CURR}

echo_light_blue "Build kernel and drivers Done."
