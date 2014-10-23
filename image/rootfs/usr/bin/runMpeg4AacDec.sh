#!/bin/sh

amixer_find="/usr/bin/amixer"
if [ ! -f $amixer_find ]; then
        echo "amixer not found"
        echo "Please connect audio output and install ALSA soundcard driver"
else
	machine_type="`cat /etc/hostname`"
	if [ "$machine_type" = "am335x-evm" ]; then
		resolution="`fbset | awk '/geometry/ {print $2"x"$3}'`"
		 if [ "$resolution" = "480x272" ]; then
			filename="/usr/share/ti/video/HistoryOfTIAV-WQVGA.mp4"
		else
			# Use WVGA for all other resolutions
			filename="/usr/share/ti/video/HistoryOfTIAV-WVGA.mp4"
	fi
    elif [ "$machine_type" = "dra7xx-evm" ]
    then
	    filename="/usr/share/ti/video/HistoryOfTIAV-WVGA.mp4"
    elif [ "$machine_type" = "omap5-evm" ]
    then
        filename="/usr/share/ti/video/HistoryOfTIAV-480p.mp4"
    elif [ "$machine_type" = "am437x-evm" ]
    then
        filename="/usr/share/ti/video/HistoryOfTIAV-480p.mp4"
	else
		default_display="`cat /sys/devices/platform/omapdss/manager0/display`"
		if [ "$default_display" = "dvi" ]; then
			if [ "$machine_type" = "beagleboard" ]; then
				filename="/usr/share/ti/video/HistoryOfTIAV-VGA.mp4"
			else
				filename="/usr/share/ti/video/HistoryOfTIAV-480p.mp4"
			fi
		else
			if [ "$machine_type" = "am37x-evm" ]; then
				filename="/usr/share/ti/video/HistoryOfTIAV-VGA-r.mp4"
			elif [ "$machine_type" = "am3517-evm" ]; then
				filename="/usr/share/ti/video/HistoryOfTIAV-WQVGA.mp4"
			fi
		fi
	fi
	if [ "$machine_type" = "am37x-evm" ]; then
		amixer cset name='HeadsetL Mixer AudioL1' on
		amixer cset name='HeadsetR Mixer AudioR1' on
		amixer -c 0 set Headset 1+ unmute
	elif [ "$machine_type" = "am335x-evm" ]; then
		amixer cset name='PCM Playback Volume' 127
    elif [ "$machine_type" = "omap5-evm" ]; then
		amixer cset name='PCM Playback Volume' 127
    elif [ "$machine_type" = "am437x-evm" ]; then
		amixer cset name='PCM Playback Volume' 127
	fi
	gst-launch-0.10 filesrc location=$filename ! qtdemux name=demux demux.audio_00 ! faad ! alsasink sync=false demux.video_00 ! queue ! ffdec_mpeg4 ! ffmpegcolorspace ! fbdevsink device=/dev/fb0
fi
