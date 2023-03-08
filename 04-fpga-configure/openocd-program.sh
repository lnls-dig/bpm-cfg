#!/usr/bin/env bash

# Script for flashing FPGAs
# NOTE: By now, only AFCv4 is supported by openocd-prog-flash.sh

set -auxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
FPGA_PROGRAMMING_REPOS=${SCRIPTPATH}/../foreign/fpga-programming

MCH=$1

BIN=$2
SLOT=$3

cd ${FPGA_PROGRAMMING_REPOS}
./openocd-prog-flash.sh ${BIN} afcv4_sfp xvc ${MCH} $((2540 + ${SLOT}))
