#!/bin/bash

# Checking every hour for any Authentication Failure entry founded on
# /var/log/auth.log file and update twitter status
# Calculate 1 hour ago time in unix time format
HOURAGO=$(date +%s --date "1 hour ago")

# Take the last authentication failure entry from auth.log
SMS=$(cat /var/log/auth.log | grep 'authentication failure' | tail -n1 )

# Extract the time from SMS variable and convert it to unix time format
SMSTIME=$(date -d "$(echo $SMS | awk '{print $1,$2,$3}')" +%s)

if [ $SMSTIME -gt $HOURAGO ]; then
echo "Updating Twitter Status..."
echo $SMS | awk '{print $3,$5,$9,$10,$12,$14,$15,$16}' | ttytter -silent -status=
fi

# Take the last authentication on port 22 entry from iptables.log
# You can use what port you want, by changing 22 with the corresponding port number.
FW=$(cat /var/log/iptables.log | grep 'DPT=22' | tail -n1 )

# Extract the time from SMS variable and convert it to unix time format
FWTIME=$(date -d "$(echo $FW | awk '{print $1,$2,$3}')" +%s)

if [ $FWTIME -gt $HOURAGO ]; then
echo "Updating Twitter Status..."
echo $FW | sed 's/\[ */\[/g' | awk '{print $3,$7,$8,$12,$13,$20,$22}' | ttytter -silent -status=
fi

# Now let's send a SMS if load average from the last 15 minutes is higher or equal to 2.50
# Useful in case of DDOS attacks.
# Store load average value from the last 15 minutes in a variable
load=$(uptime|awk '{print ( $(NF) ) }')
# Store the value for comparation in variable
nr=2.50
# You can edit the nr variable according to your needs.
# For example if you want a SMS if your load is above 0.50,
# edit the nr to look like nr=0.50
# Now compare the load and the nr given value.
# If load variable is greater or equal to nr,
# send a SMS with the time for which the value is achieved
# and the load average of the past 1,10 and 15 minutes.

if [ $(echo "$load >= $nr" | bc) -eq 1 ]; then
echo "Updating Twitter Status..."
echo $(uptime | awk '{print "Time: $1,"-",$(NF-4),$(NF-3),$(NF-2),$(NF-1),$(NF)}') | ttytter -silent -status=
fi