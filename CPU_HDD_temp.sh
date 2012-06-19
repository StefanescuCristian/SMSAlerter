#!/bin/bash
hdd=$( hddtemp /dev/sda | awk '{print $NF}' | tr -d "[°C]" )
cpu=$( sensors | tail -2 | head -1 | awk '{print $3}' | sed 's/^.//' | tr -d "[°C]" )
cpu_temp_alerta=60.0

if [ $(echo "$cpu > $cpu_temp_alerta" | bc) -eq 1 ]; then
ttytter -silent -status="Temperatura CPU: $cpu°C. Temperatura HDD: $hdd°C"
fi
