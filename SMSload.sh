#!/bin/bash
# Let's send a SMS if load average from the last 15 minutes is higher or equal to 1.00
# Store load average value from the last 15 minutes in a variable
load=$(uptime|awk '{print ( $(NF) ) }')
# Store the value for comparation in variable
nr=1.00
# You can edit the nr variable according to your needs.
# For example if you want a SMS if your load is above 0.50,
# edit the nr to look like nr=0.50

# Compare the load and the nr given value:
if [ $(echo "$load >= $nr"| bc) -eq 1 ]; then
# If load variable is greater or equal to nr,
#send a SMS with the time for which the value is achieved
#and the load average of the past 1, 10 and 15 minutes.
echo $(uptime | awk '{print "Time: " $1,"-",$(NF-4),$(NF-3),$(NF-2),$(NF-1),$(NF)}') | twidge update
