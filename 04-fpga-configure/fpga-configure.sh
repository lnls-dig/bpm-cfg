#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

FPGA_BITSTREAMS_DIR_REL=bitstreams
FPGA_BITSTREAMS_DIR=${SCRIPTPATH}/${FPGA_BITSTREAMS_DIR_REL}
MCH_PORT_BASE=2540

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

## Ask sudo password only once and
## keep updating sudo timestamp to
## avoid asking again
#sudo -v
#while true; do sudo -n true; sleep 60; kill -0 "$$" || \
#    exit; done 2>/dev/null &
#
### Install packages
#sudo apt-get update && \
#sudo apt-get install -y \
#    wget

exec_cmd "INFO " echo "Checking nsvf files..."

NSVF_EXTENSION=.nsvf
# Download bitstreams
mkdir -p ${FPGA_BITSTREAMS_DIR}
for i in `seq 0 $((${#URL_FPGA_ALL[@]}-1))`; do
    if [ ! -z ${URL_FPGA_ALL[$i]} ]; then
        bash -c "\
            SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
            . \${SCRIPTPATH}/../misc/functions.sh && \
            cd ${FPGA_BITSTREAMS_DIR}; \
            if [ ! -f ${FPGA_BITSTREAMS_ALL[$i]}${NSVF_EXTENSION} ]; then
                exec_cmd \"ERR  \" echo \"File \
                    ${FPGA_BITSTREAMS_ALL[$i]}${NSVF_EXTENSION} not found.\" >&2
                exit 1
            fi \
        "
    fi
done


exec_cmd "INFO " echo "Flashing FPGA Gateware of all boards..."

BPM_MAX_NUM_BOARDS=12
for i in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do
    bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${i}]"
    bpm_crate_fpga=${!bpm_crate_fpga_raw}

    # Get real FPGA bitstream name
    case ${bpm_crate_fpga} in
        "timing")
            board_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_TIMING_BITSTREAM}
        ;;
        "fofb")
            board_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_FOFB_BITSTREAM}
        ;;
        "pbpm")
            board_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_PBPM_BITSTREAM}
        ;;
        "sr")
            board_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_SR_BITSTREAM}
        ;;
        "bo")
            board_fpga=${FPGA_BITSTREAMS_DIR}/${FPGA_BO_BITSTREAM}
        ;;
        "")
            # Skip it
            continue
        ;;
        *)
            exec_cmd "ERR  " echo "Invalid FPGA bitstream type: ${bpm_crate_fpga}" >&2
            exit 1
        ;;
    esac

    ${SCRIPTPATH}/program-bpms.sh ${MCH_IP} "$((${MCH_PORT_BASE}+${i})),${board_fpga},$((${i}-1))" ${CRATE_NUMBER} | \
        tee -a log_bpm_${CRATE_NUMBER}.log 2>&1 || \
        true
done
