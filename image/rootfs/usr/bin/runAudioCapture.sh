#!/bin/sh

amixer_find="/usr/bin/amixer"
if [ ! -f $amixer_find ]; then
    echo "amixer not found"
    echo "Please connect audio output and install ALSA soundcard driver"
    exit
elif grep -q "no soundcards" /proc/asound/cards; then
    echo "No sound devices found!"
    exit
else
    machine_type="`cat /etc/hostname`"
    filename=$( mktemp )

    echo ""

    resolution="`fbset | awk '/geometry/ {print $2"x"$3}'`"
    if [ "$resolution" = "480x272" ]; then
           echo "No sound input device is available on this EVM."
           exit
    fi

    if [ "$machine_type" = "am37x-evm" ]; then
        amixer cset name='HeadsetL Mixer AudioL1' on > /dev/null
        amixer cset name='HeadsetR Mixer AudioR1' on > /dev/null
        amixer -c 0 set Headset 1+ unmute > /dev/null
        amixer cset name='Analog Left AUXL Capture Switch' 1  > /dev/null
        amixer cset name='Analog Right AUXR Capture Switch' 1 > /dev/null
        amixer sset 'Headset' 60%,60% > /dev/null
    elif [ "$machine_type" = "am335x-evm" ]; then
        amixer cset name='PCM Playback Volume' 80%,80% > /dev/null
        amixer cset name='PGA Capture Volume' 65%,65% > /dev/null
        amixer sset 'Right PGA Mixer Line1R' on > /dev/null
        amixer sset 'Right PGA Mixer Line1L' on > /dev/null
        amixer sset 'Left PGA Mixer Line1R' on > /dev/null
        amixer sset 'Left PGA Mixer Line1L' on > /dev/null
        amixer sset 'Left Line1R Mux' differential > /dev/null
        amixer sset 'Right Line1L Mux' differential > /dev/null
    fi

    echo "Recording of 1000 buffers from Line-In will begin in 5 seconds..."
    sleep 5

    echo ""

    echo "Starting capture pipeline..."
    gst-launch-0.10 alsasrc device="default" num-buffers=1000 ! wavenc ! filesink location=$filename

    echo ""

    echo "Starting playback pipeline..."
    gst-launch-0.10 filesrc location=$filename ! wavparse ! alsasink device="default"

    echo ""
    echo "Done."
fi

