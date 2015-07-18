#!/bin/bash
if [ $(echo "`uptime|awk '{print ( $(NF) ) }' | sed 's/,/./g'` >= 1" | bc) == 1 ]; then
        ttytter -silent -status="`uptime | awk '{print "Time: "$1,"-",$(NF-4),$(NF-3),$(NF-2),$(NF-1),$(NF)}'` Temperature: `vcgencmd measure_temp | sed 's/.*=//g' | sed "s/'.*//g"`"
fi

if [ `uptime | grep days &>/dev/null && echo 0` != "0" ]; then
        ttytter -silent -status="Your system rebooted. Up since: `uptime -s`"
fi
