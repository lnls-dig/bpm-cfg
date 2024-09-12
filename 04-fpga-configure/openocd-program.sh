#!/usr/bin/env bash

# Script for flashing FPGAs via OpenOCD

set -auo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
FPGA_PROGRAMMING_REPOS=${SCRIPTPATH}/../foreign/fpga-programming

MCH=$1

BIN=$2
AFC_TYPE=$3
SLOT=$4

cd ${FPGA_PROGRAMMING_REPOS}
./openocd-prog-flash.sh ${BIN} ${AFC_TYPE} xvc ${MCH} $((2540 + ${SLOT}))
./openocd-boot-flash.sh ${AFC_TYPE} xvc ${MCH} $((2540 + ${SLOT}))
