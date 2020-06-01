#!/bin/bash
clear
printf "Warming the Luma cache...\n"
sleep 1
wget --quiet "http://luma.com/pub/luma_b2c.xml" --no-cache --output-document - | egrep -o "http://luma.com[^<]+" | while read line; do
    time curl -A 'Cache Warmer' -s -L $line > /dev/null 2>&1
    echo $line
done
printf "done."
sleep 1
clear
printf "Warming the Venia cache...\n"
sleep 1
wget --quiet "http://luma.com/pub/venia_b2c.xml" --no-cache --output-document - | egrep -o "http://luma.com[^<]+" | while read line; do
    time curl -A 'Cache Warmer' -s -L $line > /dev/null 2>&1
    echo $line
done
printf "done."
sleep 1
clear
printf "Warming the Custom cache...\n"
sleep 1
wget --quiet "http://custom-demo.com/pub/custom_b2c.xml" --no-cache --output-document - | egrep -o "http://custom-demo.com[^<]+" | while read line; do
    time curl -A 'Cache Warmer' -s -L $line > /dev/null 2>&1
    echo $line
done
sleep 1
printf "done.\n"