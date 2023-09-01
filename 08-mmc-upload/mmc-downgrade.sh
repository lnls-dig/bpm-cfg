#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}

OPENMMC_VERSION="v1.5.0"

AFCv3_BPM_BINARY="openMMC-afcv3.1-bpm-${OPENMMC_VERSION}.hpm"
AFCv3_TIMING_BINARY="openMMC-afcv3.1-timing-${OPENMMC_VERSION}.hpm"
AFCv4_BINARY="openMMC-afcv4-${OPENMMC_VERSION}.hpm"


# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 3 ]; then
    echo "Usage: ./mmc-upload.sh <MCH Hostname> <Crate Number> <Commit Hash>"
    exit 1
fi

MCH_IP="$1"
CRATE_NUMBER="$2"
COMMIT_HASH="$3"

set +e
set -u
#Program binaries
exec_cmd "INFO " echo "Programming MMCs..."
BPM_MAX_NUM_BOARDS=12
for slot in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

  bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
  bpm_crate_fpga=${!bpm_crate_fpga_raw}

  case ${bpm_crate_fpga} in
    "timing")
      binary=${MMC_BINARIES_DIR}/${AFCv3_TIMING_BINARY}
    ;;
    "fofb")
      binary=${MMC_BINARIES_DIR}/${AFCv4_BINARY}
    ;;
    "pbpm")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BPM_BINARY}
    ;;
    "sr")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BPM_BINARY}
    ;;
    "bo")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BPM_BINARY}
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
  echo y | ~/sw/ipmitool/bin/ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) hpm upgrade ${binary} activate
  sleep 10
  COMMIT_HASH_READ=$(ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x02 | tr -d " " | tr -d "\n")
  echo "Hash read: ${COMMIT_HASH_READ}"
  echo "Slot ${slot} programed"
done
