#!/usr/bin/env bash

MCH_IP="$1"
SLOT="$2"
#BINARIE_OLD="$3"
#BINARIE_NEW="$3"

while [ 1 ]; do
  #echo y | ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${SLOT})) hpm upgrade ${BINARIE_OLD} activate && break
  #sleep 3
  #echo y | ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${SLOT})) hpm upgrade ${BINARIE_NEW} activate && break
  #sleep 3
  ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t $((112 + 2*${SLOT})) raw 0x32 0x02
  ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t $((112 + 2*${SLOT})) raw 0x32 0x04
  ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t $((112 + 2*${SLOT})) fru print
done
