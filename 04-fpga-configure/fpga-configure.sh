#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

# Source FPGA bitstreams
. ${SCRIPTPATH}/fpga-bitstreams.sh

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 2 ]; then
    echo "Usage: ./fpga-configure.sh <MCH IP> <Crate Number>"
    exit 1
fi

MCH_IP="$1"
CRATE_NUMBER_="$2"
# Remove leading zeros
CRATE_NUMBER="$(echo ${CRATE_NUMBER_} | sed 's/^0*//')"

set -u

# Check if repo was cloned with fpga-programming submodule
[ ! -z "$(ls -A "${SCRIPTPATH}/../foreign/fpga-programming")" ] || \
    git submodule update --init

exec_cmd "INFO " echo "Flashing FPGA gateware of all boards..."

BPM_MAX_NUM_BOARDS=12
for slot in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

  bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
  bpm_crate_fpga=${!bpm_crate_fpga_raw}

  # Get real FPGA bitstream name
  case ${bpm_crate_fpga} in
    "timing")
      board_fpga=g${FPGA_TIMING_BITSTREAM}
    ;;
    "fofb")
      board_fpga=g${FPGA_FOFB_BITSTREAM}
    ;;
    "pbpm")
      board_fpga=g${FPGA_PBPM_BITSTREAM}
    ;;
    "sr")
      board_fpga=g${FPGA_SR_BITSTREAM}
    ;;
    "bo")
      board_fpga=g${FPGA_BO_BITSTREAM}
    ;;
    "")
      # Skip it
      continue
    ;;
    *)
      exec_cmd "ERR  " echo "Invalid bitstream type: ${bpm_crate_fpga}" >&2
      exit 1
    ;;
  esac

  case ${bpm_crate_fpga} in
    "timing" | "pbpm" | "sr" | "bo")
      # AFCv3.1 uses curl
      ${SCRIPTPATH}/curl-program.sh ${MCH_IP} "${board_fpga},$((${slot} - 1))" | \
        tee -a log_bpm_${CRATE_NUMBER}.log 2>&1 || \
        true
    ;;
    "fofb")
      # AFCv4 uses openocd
      ${SCRIPTPATH}/openocd-program.sh ${MCH_IP} ${board_fpga} ${slot} | \
        tee -a log_bpm_${CRATE_NUMBER}.log 2>&1 || \
        true
    ;;
    "")
      # Skip it
      continue
    ;;
  esac
done
