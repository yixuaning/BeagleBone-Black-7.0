#!/bin/sh

machine_type="`cat /etc/hostname`"
if [ "$machine_type" = "am335x-evm" ]; then
	resolution="`fbset | awk '/geometry/ {print $2"x"$3}'`"
	if [ "$resolution" = "480x272" ]; then
		filename="/usr/share/ti/video/HistoryOfTI-WQVGA.m4v"
	else
		 # Use WVGA for all other resolutions
		filename="/usr/share/ti/video/HistoryOfTI-WVGA.m4v"
	fi
elif [ "$machine_type" = "dra7xx-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-WVGA.m4v"
elif [ "$machine_type" = "omap5-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-480p.m4v"
elif [ "$machine_type" = "am437x-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-480p.m4v"
else
	default_display="`cat /sys/devices/platform/omapdss/manager0/display`"
	if [ "$default_display" = "dvi" ]; then
        	if [ "$machine_type" = "beagleboard" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-VGA.m4v"
        	else
                	filename="/usr/share/ti/video/HistoryOfTI-480p.m4v"
        	fi
	else
        	if [ "$machine_type" = "am37x-evm" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-VGA-r.m4v"
        	elif [ "$machine_type" = "am3517-evm" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-WQVGA.m4v"
        	fi
	fi
fi
if [ ! -f $filename ]; then
        echo "Video clip not found"
        exit 1
fi
gst-launch-0.10 filesrc location=$filename ! mpeg4videoparse ! ffdec_mpeg4 ! ffmpegcolorspace ! fbdevsink
