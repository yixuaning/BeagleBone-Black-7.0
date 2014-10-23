#!/bin/sh

pidof matrix_browser > /dev/null 2>&1
if [ $? == 0 ]
then
	/usr/bin/qtopia/demos/deform/deform -small-screen
else
export TSLIB_TSDEVICE=/dev/input/touchscreen0
export QWS_MOUSE_PROTO=Tslib:/dev/input/touchscreen0
	/usr/bin/qtopia/demos/deform/deform -small-screen -qws
fi
