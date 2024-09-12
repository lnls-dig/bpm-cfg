#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

# Source FPGA bitstreams
. ${SCRIPTPATH}/fpga-bins.sh

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

exec_cmd "INFO " echo "Flashing FPGA gateware of all boards..."

BPM_MAX_NUM_BOARDS=12
for slot in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

  bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
  bpm_crate_fpga=${!bpm_crate_fpga_raw}

  afc_type="afcv3"
  # Get real FPGA bitstream name
  case ${bpm_crate_fpga} in
    "timing")
      if [ -n "$FPGA_TIMING_BIN" ]; then
        board_fpga=${FPGA_TIMING_BIN}
      else
        continue
      fi
    ;;
    "fofb")
      if [ -n "$FPGA_FOFB_BIN" ]; then
        afc_type="afcv4_sfp"
        board_fpga=${FPGA_FOFB_BIN}
      else
        continue
      fi
    ;;
    "pbpm")
      if [ -n "$FPGA_PBPM_BIN" ]; then
        board_fpga=${FPGA_PBPM_BIN}
      else
        continue
      fi
    ;;
    "sr")
      if [ -n "$FPGA_SR_BIN" ]; then
        board_fpga=${FPGA_SR_BIN}
      else
        continue
      fi
    ;;
    "bo")
      if [ -n "$FPGA_BO_BIN" ]; then
        board_fpga=${FPGA_BO_BIN}
      else
        continue
      fi
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
    "timing" | "fofb" | "pbpm" | "sr" | "bo")
      ${SCRIPTPATH}/openocd-program.sh ${MCH_IP} ${board_fpga} ${afc_type} ${slot} | \
        tee -a log_bpm_${CRATE_NUMBER}.log 2>&1 || \
        true
    ;;
    "")
      # Skip it
      continue
    ;;
  esac
done
