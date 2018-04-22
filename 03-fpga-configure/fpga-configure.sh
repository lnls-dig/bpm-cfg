#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

FPGA_BITSTREAMS_DIR_REL=bitstreams
FPGA_BITSTREAMS_DIR=${SCRIPTPATH}/${FPGA_BITSTREAMS_DIR_REL}
MCH_PORT_BASE=2540

# Source FPGA mapping
. ${SCRIPTPATH}/crate-fpga-mapping.sh
# Source FPGA bitstreams
. ${SCRIPTPATH}/fpga-bitstreams.sh

MCH_IP="$1"
CRATE_NUMBER="$2"

# Ask sudo password only once and
# keep updating sudo timestamp to
# avoid asking again
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || \
    exit; done 2>/dev/null &

## Install packages
sudo apt-get update && \
sudo apt-get install -y \
    curl

BITSTREAM_SUFFIX=.bit
# Download bitstreams
mkdir -p ${FPGA_BITSTREAMS_DIR}
for i in `seq 0 $((${#URL_FPGA_ALL[@]}-1))`; do
    if [ ! -z ${URL_FPGA_ALL[i]} ]; then
        bash -c "\
            cd ${FPGA_BITSTREAMS_DIR} && \
            curl -L ${URL_FPGA_ALL[i]}${BITSTREAM_SUFFIX} > ${FPGA_BITSTREAMS_ALL[i]}${BITSTREAM_SUFFIX} \
        "
    fi
done

BPM_MAX_NUM_BOARDS=12
for i in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do
    bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${i}]"
    bpm_crate_fpga=${!bpm_crate_fpga_raw}

    # Get real FPGA bitstream name
    case ${bpm_crate_fpga} in
        "timing")
            bpm_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_TIMING_BITSTREAM}
        ;;
        "pbpm")
            bpm_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_PBPM_BITSTREAM}
        ;;
        "sr")
            bpm_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_SR_BITSTREAM}
        ;;
        "bo")
            bpm_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_BO_BITSTREAM}
        ;;
        "")
            # Skip it
            continue
        ;;
        *)
            echo "Invalid FPGA bitstream type: ${bpm_crate_fpga}" >&2
            exit 1
        ;;
    esac

    ${SCRIPTPATH}/program-bpms.sh ${MCH_IP} "$((${MCH_PORT_BASE}+${i})),${bpm_fpga}" || \
        true
done
