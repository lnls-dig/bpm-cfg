#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

# Simple argument checking
if [ $# -lt 1 ]; then
    echo "Usage: ./mmc-download.sh <OpenMMC Version>"
    exit 1
fi
OPENMMC_VERSION="$1"
VERSION_NUM="${OPENMMC_VERSION#v}"

if [[ "$(printf '%s\n' $VERSION_NUM 1.6.0 | sort -V | head -n 1)" != 1.6.0 ]]; then
    echo "Error: Firmware version must be v1.6.0 or higher."
    exit 1
else
    exec_cmd "INFO " echo "Downloading binaries version $OPENMMC_VERSION..."
fi

OPENMMC_URL_RELEASE_BASE="https://github.com/lnls-dig/openMMC/releases/download"

AFCv3_BINARY="openMMC-afcv3.1-8sfp-${OPENMMC_VERSION}.hpm"
AFCv4_BINARY="openMMC-afcv4.0-lamp-${OPENMMC_VERSION}.hpm"

URL_FIRMWARE_AFCv3_HPM=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFCv3_BINARY}
URL_FIRMWARE_AFCv4_HPM=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFCv4_BINARY}

URL_BINARIES=(${URL_FIRMWARE_AFCv3_HPM}
              ${URL_FIRMWARE_AFCv4_HPM})



# Download binaries
mkdir -p ${MMC_BINARIES_DIR}

for i in ${URL_BINARIES[@]}; do
    bash -c "\
            SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
            . \${SCRIPTPATH}/../misc/functions.sh && \
            cd ${MMC_BINARIES_DIR}; \
            exec_cmd \"INFO\" wget ${i}\
        "
done
