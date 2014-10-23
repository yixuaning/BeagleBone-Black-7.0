#!/bin/sh

machine_type="`cat /etc/hostname`"
if [ "$machine_type" = "am335x-evm" ]; then
	resolution="`fbset | awk '/geometry/ {print $2"x"$3}'`"
	if [ "$resolution" = "480x272" ]; then
		filename="/usr/share/ti/video/HistoryOfTI-WQVGA.264"
	else
		# Use WVGA for all other resolutions
		filename="/usr/share/ti/video/HistoryOfTI-WVGA.264"
	fi
elif [ "$machine_type" = "dra7xx-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-WVGA.264"
elif [ "$machine_type" = "omap5-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-480p.264"
elif [ "$machine_type" = "am437x-evm" ]
then
    filename="/usr/share/ti/video/HistoryOfTI-480p.264"
else
	default_display="`cat /sys/devices/platform/omapdss/manager0/display`"
	if [ "$default_display" = "dvi" ]; then
        	if [ "$machine_type" = "beagleboard" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-VGA.264"
        	else
                	filename="/usr/share/ti/video/HistoryOfTI-480p.264"
        	fi
	else
        	if [ "$machine_type" = "am37x-evm" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-VGA-r.264"
        	elif [ "$machine_type" = "am3517-evm" ]; then
                	filename="/usr/share/ti/video/HistoryOfTI-WQVGA.264"
        	fi
	fi
fi
if [ ! -f $filename ]; then
        echo "Video clip not found"
        exit 1
fi
echo ""
echo "Launch GStreamer pipeline"
echo ""
echo "Length of video clip: 18 seconds"
gst-launch-0.10 -v filesrc location=$filename ! h264parse ! ffdec_h264 ! ffmpegcolorspace ! fbdevsink device=/dev/fb0
