#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

FRU_BINARIES_DIR_REL=fru_binaries
FRU_BINARIES_DIR=${SCRIPTPATH}/${FRU_BINARIES_DIR_REL}
mkdir -p ${FRU_BINARIES_DIR}

set +u

# Simple argument checking
if [ $# -lt 2 ]; then
    echo "Usage: ./update-fru.sh <Crate Number> [arguments for set-fru-info.py]"
    exit 1
fi

CRATE_NUMBER="$1"
shift
FRU_ARGS="$@"

crate_ip_raw="BPM_CRATE_${CRATE_NUMBER}_MCH_HOSTNAME"
crate_ip=${!crate_ip_raw}

set -u

ipmitool -I lan -H ${crate_ip} -A none -T 0x82 -m 0x20 -t 116 fru read 0 ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-read.bin
if [[ $? != 0 ]]; then
    echo "FRU read failed. Crate ${crate_ip}"
    exit 1
fi

# Pass additional arguments to the Python script
./set-fru-info.py --bin-in ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-read.bin --bin-out ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-write.bin ${FRU_ARGS}

ipmitool -I lan -H ${crate_ip} -A none -T 0x82 -m 0x20 -t 116 fru write 0 ${FRU_BINARIES_DIR}/rack-${CRATE_NUMBER}-write.bin
if [[ $? != 0 ]]; then
    echo "FRU write failed. Crate ${crate_ip}"
    exit 1
fi

# AFCv4 FRUID is always 6
./fru_hard_rst.expect ${crate_ip} "6"

ipmitool -I lan -H ${crate_ip} -A none -T 0x82 -m 0x20 -t 116 fru print 0
