#!/usr/bin/env bash

set -auxo pipefail

for i in `seq -f %02g 2 20`; do

    crate_num=$(echo ${i} | sed 's/^0*//')
    crate_name=$(echo IA-${i}RaBPM-CO-CrateCtrl)
    crate_date=$(date  +%Y%m%d-%H%M%S)
    ./fpga-configure.sh ${crate_name} ${crate_num} &

done

for i in `seq -f %02g 21 21`; do

    crate_num=$(echo ${i} | sed 's/^0*//')
    crate_name=$(echo IA-RaBPMTL-CO-CrateCtrl)
    crate_date=$(date  +%Y%m%d-%H%M%S)
    ./fpga-configure.sh ${crate_name} ${crate_num} &

done
