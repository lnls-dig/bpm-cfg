#!/usr/bin/env bash

# Script for flashing FPGAs via OpenOCD

set -auo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
FPGA_PROGRAMMING_REPOS=${SCRIPTPATH}/../foreign/fpga-programming

MCH=$1

BIN_BIT=$2
AFC_TYPE=$3
SLOT=$4

echo $BIN_BIT

cd ${FPGA_PROGRAMMING_REPOS}
if [ ${BIN_BIT: -4} == ".bin" ]; then
	./openocd-prog-flash.sh ${BIN_BIT} ${AFC_TYPE} xvc ${MCH} $((2540 + ${SLOT}))
	./openocd-boot-flash.sh ${AFC_TYPE} xvc ${MCH} $((2540 + ${SLOT}))
elif [ ${BIN_BIT: -4} == ".bit" ]; then
	./openocd-prog.sh ${BIN_BIT} ${AFC_TYPE} xvc ${MCH} $((2540 + ${SLOT}))
else
	echo "Unknown file extension:" "$BIN_BIT"
	exit 1
fi
