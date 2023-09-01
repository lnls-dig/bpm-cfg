#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source AFCv4 mapping
CSV_PATH=${SCRIPTPATH}/../misc/AFCv4List.csv

FRU_BINARIES_DIR_REL=fru_binaries
FRU_BINARIES_DIR=${SCRIPTPATH}/${FRU_BINARIES_DIR_REL}
mkdir -p ${FRU_BINARIES_DIR}

set +u

# Simple argument checking
if [ $# -lt 2 ]; then
    echo "Usage: ./update-fru.sh <MCH HOSTNAME> <Crate Number>"
    exit 1
fi

MCH_IP="$1"
CRATE_NUMBER="$2"

set -u

ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t 116 fru read 0 ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-read.bin

if [[ $? != 0 ]]; then
	echo "FRU read failed. Crate ${MCH_IP}"
	exit 1
fi


#. ${SCRIPTPATH}/set-fru-info.py --csv-in ${CSV_PATH} --rack_number ${CRATE_NUMBER} --bin-in ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-read.bin --bin-out ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-write.bin
./set-fru-info.py --csv-in ${CSV_PATH} --rack_number ${CRATE_NUMBER} --bin-in ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-read.bin --bin-out ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-write.bin

ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t 116 fru write 0 ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-write.bin

if [[ $? != 0 ]]; then
	echo "FRU write failed. Crate ${MCH_IP}"
	exit 1
fi

./fru_hard_rst.expect ${MCH_IP} "6"

ipmitool -I lan -H ${MCH_IP} -A none -T 0x82 -m 0x20 -t 116 fru print 0
