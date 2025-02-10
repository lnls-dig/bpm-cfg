#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 2 ]; then
    echo "Usage: ./mmc-upload.sh <Crate Number> <OpenMMC Version>"
    exit 1
fi

CRATE_NUMBER="$1"
OPENMMC_VERSION="$2"

set -u

# Expect the firmwares to be in the binaries diretory
MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}
AFCv3_BINARY="openMMC-afcv3.1-8sfp-${OPENMMC_VERSION}.hpm"
AFCv4_BINARY="openMMC-afcv4.0-lamp-${OPENMMC_VERSION}.hpm"

# Read the Commit SHA from the given firmware version
COMMIT_HASH=$(git ls-remote https://github.com/lnls-dig/openMMC.git refs/tags/${OPENMMC_VERSION} | cut -f1 | tr -d "\n")

# Get the crate ip from crate-fpga-mapping.sh using the crate number
crate_ip_raw="BPM_CRATE_${CRATE_NUMBER}_MCH_HOSTNAME"
crate_ip=${!crate_ip_raw}

set +e

exec_cmd "INFO " echo "Programming MMCs..."
for slot in `seq 1 12`; do

    # Select the corresponding binary according to crate-fpga-mapping.sh
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

    COMMIT_HASH_READ=$(ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x02 | tr -d " " | tr -d "\n")
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        echo "Hash read failed! Slot ${slot} Crate ${crate_ip}"
        exit 1
    fi

    # If we already have a hash match, there is no need to update
    if [[ ${COMMIT_HASH_READ} = ${COMMIT_HASH} ]]; then
        echo "Slot ${slot} Crate ${crate_ip} already updated. Skipping..."
        continue
    fi

    # Update the firmware
    echo y | ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) hpm upgrade ${binary} activate

    sleep 10

    # Read the commit hash to check if the update was successfully
    COMMIT_HASH_READ=$(ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x02 | tr -d " " | tr -d "\n")
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        echo "Hash read failed! Slot ${slot} Crate ${crate_ip}"
        exit 1
    fi

    # Retry the update if the hash compare fails
    counter=0
    while [[ ${COMMIT_HASH_READ} != ${COMMIT_HASH} ]]
    do
        echo "Hash compare failed! Slot ${slot} Crate ${crate_ip}"
        # Only trie 3 times
        if [ $counter -gt 3 ]; then
            echo "Read Hash: ${COMMIT_HASH_READ}"
            echo "Giving up..."
            exit 1
        fi

        # Hard Reset the board before retry
        ./fru_hard_rst.expect ${crate_ip} "$((${slot} + 4))"

        echo ""
        sleep 5
        echo y | ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) hpm upgrade ${binary} activate
        sleep 10
        COMMIT_HASH_READ=$(ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x02 | tr -d " " | tr -d "\n")
        counter=$(( counter + 1 ))
    done

    echo "Slot ${slot} programed"
done

exec_cmd "INFO " echo "Upgrade Done :)"
