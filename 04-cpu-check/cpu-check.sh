#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

MAPPING_DIR="misc"
MAPPING_FILE="crate-fpga-mapping.sh"

set +u

# Simple argument checking
if [ $# -lt 3 ]; then
    echo "Usage: ./cpu-check.sh <CPU IP> <Crate Number> <CPU SSH root password>"
    exit 1
fi

IP="$1"
CRATE_NUMBER_="$2"
# Remove leading zeros
CRATE_NUMBER="$(echo ${CRATE_NUMBER_} | sed 's/^0*//')"
SSHPASS_USR="$3"

set -u

# Source mapping file
. ${SCRIPTPATH}/../${MAPPING_DIR}/${MAPPING_FILE}

exec_cmd "TRACE" echo "Reading Crate #${CRATE_NUMBER} FPGA mapping..."

# Get board numbers from crate-mapping.sh file
BPM_MAX_NUM_BOARDS=12
BPM_FPGA_AVAILABLE=()
for i in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do
    BPM_CRATE_FPGA_="BPM_CRATE_${CRATE_NUMBER}_FPGA[$i]"
    BPM_CRATE_FPGA="${!BPM_CRATE_FPGA_}"

    if [ ! -z "${BPM_CRATE_FPGA}" ]; then
        BPM_FPGA_AVAILABLE+=("$i")
    fi
done

exec_cmd "INFO " echo "Boards slots to check: ${BPM_FPGA_AVAILABLE[@]}"

${SCRIPTPATH}/cpu-check-raw.sh ${IP} ${SSHPASS_USR} ${BPM_FPGA_AVAILABLE[@]}
