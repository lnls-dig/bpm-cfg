#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA bitstreams
. ${SCRIPTPATH}/mch-firmwares.sh

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

# MCH config arguments
MCH_CONFIG_ARGS="$@"

MCH_FIRMWARES_DIR_REL=firmwares
MCH_FIRMWARES_DIR=${SCRIPTPATH}/${MCH_FIRMWARES_DIR_REL}

exec_cmd "INFO  " echo "Downloading MCH Firmware..."

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

exec_cmd "INFO  " echo "Setting up TFTP server..."

# Call actual serial config
${SCRIPTPATH}/serial-config.sh

exec_cmd "INFO  " echo "Configuring MCH..."

# Call actual MCH config script
${SCRIPTPATH}/mch-config.exp ${MCH_CONFIG_ARGS}
