#!/bin/bash
# Cristian Stefanescu version
# Using the GPL Licence, I must provide the original source of the script:
# http://pastebin.com/WZjaupQi
# You should have two Twitter accounts, be logged on with the second one, accept the API access,
# and follow your second account from the first one,
# enabling SMS sending for every statusupdate
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# Copyright (C) 2012 by +Mitesh Shah
# https://github.com/MiteshShah/SecurityAlert
# Mr.Miteshah@gmail.com
# People who works on this script to make it easier and good
# +Chris Raess +Josh Sabboth and +Christopher Timm
# People who want to use this script in their Mac OS X
# Read the +Israel Torres comments on this post

# <beginning of Mitesh Shah original work>
# Checking every hour for any Authentication Failure entry founded on
# /var/log/auth.log file and update twitter status

# You should need to create a crontab entry for this script
# So this script runs every hours automatically

# If using the original part of the script plus added functionalities
# you should add a cronjob for every 5 minutes
# Calculate 1 hour ago time in unix time format
HOURAGO=$(date +%s --date "1 hour ago")

# Take the last authentication failure entry from auth.log
SMS=$(cat /var/log/auth.log | grep 'authentication failure' | tail -n1 )

# Extract the time from SMS variable and convert it to unix time format
SMSTIME=$(date -d "$(echo $SMS | awk '{print $1,$2,$3}')" +%s)

if [ $SMSTIME -gt $HOURAGO ]; then
echo "Updating Twitter Status..."
echo $SMS | awk '{print $3,$5,$9,$10,$12,$14,$15,$16}' | twidge update
fi

# <end of Mitesh Shah original work>

# The following part of the script is created by Cristian Stefanescu.
# It's based and inspired from the work of Mitesh Shah (above)
# and added some new functionalities

# If you have ufw firewall, you can view the last log from a specific port.
# In my example it's port 2150.
# You should edit the grep command and use the port number of your needs
# I think it also works with kernel.log or syslog, just edit the file from cat command

# Take the last port entry from ufw.log
FW=$(cat /var/log/ufw.log | grep 'DPT=2150' | tail -n1 )

# Extract the time from FW variable and convert it to unix time format
FWTIME=$(date -d "$(echo $FW | awk '{print $1,$2,$3}')" +%s)

if [ $FWTIME -gt $HOURAGO ]; then
echo "Updating Twitter Status..."
echo $FW | sed 's/\[ */\[/g' | awk '{print $3,$8,$9,$13,$14,$21,$23}' | twidge update
fi
#sed is used for deleting the space between the kernel log [ no.no] when overpopulating the log.

# Now let's send a SMS if load average from the last 15 minutes is higher or equal to 1.00
# Store load average value from the last 15 minutes in a variable
load=$(uptime|awk '{print ( $(NF) ) }')
# Store the value for comparation in variable
nr=1.00
# You can edit the nr variable according to your needs.
# For example if you want a SMS if your load is above 0.50,
# edit the nr to look like nr=0.50
# Now compare the load and the nr given value.
if [ $(echo "$load >= $nr"| bc) -eq 1 ]; then
# If load variable is greater or equal to nr,
#send a SMS with the time for which the value is achieved
#and the load average of the past 1,10 and 15 minutes.
echo $(uptime | awk '{print "Time: " $1,"-",$(NF-4),$(NF-3),$(NF-2),$(NF-1),$(NF)}') | twidge update
fi

fi
