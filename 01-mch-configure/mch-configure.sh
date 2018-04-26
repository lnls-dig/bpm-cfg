#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA bitstreams
. ${SCRIPTPATH}/mch-firmwares.sh

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh
# Source Crate FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

set +u

# Simple argument checking
if [ $# -lt 3 ]; then
    echo "Usage: ./mch-configure.sh <Connection Type> [<MCH IP> <MCH Password>] <FTP Server Address> <Crate Number>"
    exit 1
fi

# MCH config arguments
MCH_CONN_TYPE="$1"

if [ ${MCH_CONN_TYPE} == "ssh" ]; then
    MCH_IPADDR="$2"
    MCH_PASS="$3"
    TFTP_IPADDR="$4"
    CRATE_NUMBER_="$5"
elif [ ${MCH_CONN_TYPE} == "serial" ]; then
    TFTP_IPADDR="$2"
    CRATE_NUMBER_="$3"
else
    exec_cmd "ERR  " echo "Invalid MCH Connection Type. Valid options are \"ssh\" or \"serial\""
    exit 1
fi

# Remove leading zeros
CRATE_NUMBER="$(echo ${CRATE_NUMBER_} | sed 's/^0*//')"

set -u

# Get MCH Hostname
MCH_HOSTNAME_="BPM_CRATE_${CRATE_NUMBER}_MCH_HOSTNAME"
MCH_HOSTNAME="${!MCH_HOSTNAME_}"

MCH_FIRMWARES_DIR_REL=firmwares
MCH_FIRMWARES_DIR=${SCRIPTPATH}/${MCH_FIRMWARES_DIR_REL}

exec_cmd "INFO " echo "Downloading MCH Firmware..."

mkdir -p ${MCH_FIRMWARES_DIR}
# Just copy the mch_fw.bin to firmwares folder
for i in `seq 0 $((${#URL_MCH_FIRMWARES_ALL[@]}-1))`; do
    if [ ! -z ${URL_MCH_FIRMWARES_ALL[$i]} ]; then
        bash -c "\
            SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
            . \${SCRIPTPATH}/../misc/functions.sh && \
            cd ${MCH_FIRMWARES_DIR}; \
            if [ ! -f ${MCH_FIRMWARES_ALL[$i]} ]; then
                echo \"MCH Firmware \"${MCH_FIRMWARES_ALL[$i]}\" not found. \
                    Please copy the file to \"${MCH_FIRMWARES_DIR}\" folder\"
                exit 1
            fi \
        "
    fi
done

exec_cmd "INFO " echo "Setting up TFTP server..."

# Call actual serial config
${SCRIPTPATH}/serial-config.sh

exec_cmd "INFO " echo "Configuring MCH..."


if [ ${MCH_CONN_TYPE} == "ssh" ]; then
    MCH_IPADDR="$2"
    MCH_PASS="$3"
    TFTP_IPADDR="$4"
    CRATE_NUMBER="$5"
    # Call actual MCH config script
    ${SCRIPTPATH}/mch-config.exp ${MCH_CONN_TYPE} ${MCH_IPADDR} ${MCH_PASS} ${TFTP_IPADDR} ${MCH_HOSTNAME}
elif [ ${MCH_CONN_TYPE} == "serial" ]; then
    # Call actual MCH config script
    ${SCRIPTPATH}/mch-config.exp ${MCH_CONN_TYPE} ${TFTP_IPADDR} ${MCH_HOSTNAME}
fi
