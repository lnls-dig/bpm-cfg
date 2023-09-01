#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}

OPENMMC_URL_RELEASE_BASE="https://github.com/lnls-dig/openMMC/releases/download"
OPENMMC_VERSION="v1.6.0"

AFCv3_BINARY="openMMC-afcv3.1-8sfp-${OPENMMC_VERSION}.hpm"
AFCv4_BINARY="openMMC-afcv4.0-lamp-${OPENMMC_VERSION}.hpm"

URL_FIRMWARE_AFCv3_HPM=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFCv3_BINARY}
URL_FIRMWARE_AFCv4_HPM=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFCv4_BINARY}

URL_BINARIES=(${URL_FIRMWARE_AFCv3_HPM}
              ${URL_FIRMWARE_AFCv4_HPM})

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

exec_cmd "INFO " echo "Downloading binaries..."

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

