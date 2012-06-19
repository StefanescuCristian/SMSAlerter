#!/bin/bash

card_temp=$(aticonfig --odgt > /tmp/ati.txt; tail -1 /tmp/ati.txt |awk '{print $(NF-1)}')
alert_temp=64.99

if [ $(echo "$card_temp >  $alert_temp" | bc) -eq 1 ]; then
ttytter -silent -status="Video card temperature: $card_temp°C"
fi
