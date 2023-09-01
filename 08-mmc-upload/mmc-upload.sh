#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}

OPENMMC_VERSION="v1.6.0"

AFCv3_BINARY="openMMC-afcv3.1-8sfp-${OPENMMC_VERSION}.hpm"
AFCv4_BINARY="openMMC-afcv4.0-lamp-${OPENMMC_VERSION}.hpm"


# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 4 ]; then
    echo "Usage: ./mmc-upload.sh <MCH Hostname> <Crate Number> <Start Slot> <Commit Hash>"
    exit 1
fi

MCH_IP="$1"
CRATE_NUMBER="$2"
START_SLOT="$3"
COMMIT_HASH="$4"

set -u

set +e
#Program binaries
exec_cmd "INFO " echo "Programming MMCs..."
BPM_MAX_NUM_BOARDS=12
for slot in `seq ${START_SLOT} ${BPM_MAX_NUM_BOARDS}`; do

  bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
  bpm_crate_fpga=${!bpm_crate_fpga_raw}

  case ${bpm_crate_fpga} in
    "timing")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BINARY}
    ;;
    "fofb")
      binary=${MMC_BINARIES_DIR}/${AFCv4_BINARY}
    ;;
    "pbpm")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BINARY}
    ;;
    "sr")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BINARY}
    ;;
    "bo")
      binary=${MMC_BINARIES_DIR}/${AFCv3_BINARY}
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
  while [[ ${PIPESTATUS[0]} != 0 ]]
  do
    echo "Hash read failed! Slot ${slot} Crate ${MCH_IP}"
    ./fru_hard_rst.expect ${MCH_IP} "$((${slot} + 4))"
    echo ""
    sleep 5
    echo y | ~/sw/ipmitool/bin/ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) hpm upgrade ${binary} activate
    sleep 10
    COMMIT_HASH_READ=$(ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x02 | tr -d " " | tr -d "\n")
  done

  if [[ ${COMMIT_HASH_READ} != ${COMMIT_HASH} ]]; then
    echo "Hash compare failed! Slot ${slot} Crate ${MCH_IP}"
    echo "Read Hash: ${COMMIT_HASH_READ}"
    exit 1
  fi
  echo "Slot ${slot} programed"
done

sleep 10

#Program clocks switches
exec_cmd "INFO " echo "Programming Clock Switches..."
for slot in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

  bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
  bpm_crate_fpga=${!bpm_crate_fpga_raw}

  case ${bpm_crate_fpga} in
    "timing")
      clk_cfg="0x20 0x20 0x20 0xAF 0xAF 0x28 0xAD 0x28 0xA8 0x2D 0x2E 0x2E 0x2E 0xAF 0x2E 0x23"
    ;;
    "fofb")
      clk_cfg="0xAA 0x20 0x20 0x20 0x20 0x60 0x20 0xAA 0x20 0x20 0x60 0x20 0x20 0xA5 0x20 0xAA"
    ;;
    "pbpm")
      clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
    ;;
    "sr")
      clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
    ;;
    "bo")
      clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
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
  ipmitool -I lan -H ${MCH_IP} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x03 ${clk_cfg}
  if [[ $? != 0 ]]; then
    echo "Clock configuration failed! Slot ${slot} Crate ${MCH_IP}"
    exit 1
  fi
  echo "Clock Switch configurated! Slot ${slot}"
done

#for slot in `seq 5 16`; do
#  ./fru_soft_rst.expect ${MCH_IP} ${slot}
#done

exec_cmd "INFO " echo "Upgrade Done :)"
