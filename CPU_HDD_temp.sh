#!/bin/bash
hdd=$( hddtemp /dev/sda | awk '{print $NF}' | tr -d "[°C]" )
cpu=$( sensors | tail -2 | head -1 | awk '{print $3}' | sed 's/^.//' | tr -d "[°C]" )
cpu_temp_alert=60.0

if [ $(echo "$cpu > $cpu_temp_alert" | bc) -eq 1 ]; then
ttytter -silent -status="CPU temperature: $cpu°C. HDD temperature: $hdd°C"
fi
