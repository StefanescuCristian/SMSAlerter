#!/bin/bash
hddtemp /dev/sda > /tmp/hdd
hadd=$( cat /tmp/hdd | awk '{print $NF}' | tr -d "[°C]" )
cpu=$( sensors | grep 'Core 0:' | awk '{print $3}' | sed 's/^.//' | tr -d "[°C]" )
cpu_temp_alert=60.0

if [ $(echo "$cpu > $cpu_temp_alert" | bc) -eq 1 ]; then
ttytter -silent -status="CPU temperature: $cpu°C. HDD temperature: $hadd°C"
fi
