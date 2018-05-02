#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

MMC_BINARIES_DIR_REL=binaries
MMC_BINARIES_DIR=${SCRIPTPATH}/${MMC_BINARIES_DIR_REL}

OPENMMC_URL_RELEASE_BASE="https://github.com/lnls-dig/openMMC/releases/download"
OPENMMC_VERSION="v1.1.0"

AFC_BPM_BINARY="openMMC-afc-bpm-${OPENMMC_VERSION}.bin"
AFC_TIMING_BINARY="openMMC-afc-timing-${OPENMMC_VERSION}.bin"
BOOTLOADER_BINARY="openMMC-bootloader-${OPENMMC_VERSION}.bin"

URL_OPENMMC_AFC_BPM=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFC_BPM_BINARY}
URL_OPENMMC_AFC_TIMING=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${AFC_TIMING_BINARY}
URL_OPENMMC_BOOTLOADER=${OPENMMC_URL_RELEASE_BASE}/${OPENMMC_VERSION}/${BOOTLOADER_BINARY}
URL_BINARIES=(${URL_OPENMMC_AFC_BPM}
              ${URL_OPENMMC_AFC_TIMING}
              ${URL_OPENMMC_BOOTLOADER})

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 1 ]; then
    echo "Usage: ./mmc-configure.sh <MCH IP>"
    exit 1
fi

MCH_IP="$1"

set -u

# Check if repo was cloned with hpm-downloader submodule
[ ! -z "$(ls -A "${SCRIPTPATH}/../foreign/hpm-downloader")" ] || \
    git submodule update --init

bash -c "\
    SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
    . \${SCRIPTPATH}/../misc/functions.sh && \
    cd ${SCRIPTPATH}/../foreign/hpm-downloader; \
    git checkout ffd7057 && \\
    cd ${SCRIPTPATH} \
    "

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

#Compile hpm-downloader
bash -c "\
        SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
        . \${SCRIPTPATH}/../misc/functions.sh && \
        cd ${SCRIPTPATH}/../foreign/hpm-downloader; \
        exec_cmd \"TRACE\" make\
    "

#Program binaries
exec_cmd "INFO " echo "Programming MMCs..."

BPM_MAX_NUM_BOARDS=12
for i in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

    if [ $i == 1 ]; then
        binary=${MMC_BINARIES_DIR}/${AFC_TIMING_BINARY}
    else
        binary=${MMC_BINARIES_DIR}/${AFC_BPM_BINARY}
    fi

    bash -c "\
            SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
            . \${SCRIPTPATH}/../misc/functions.sh && \
            exec_cmd \"TRACE\" ${SCRIPTPATH}/../foreign/hpm-downloader/bin/hpmdownloader -c 1 -o 0 -d 0 -n 0x315A -i 0 --early_major 0 --early_minor 0 --new_major 1 --new_minor 1 --ip ${MCH_IP} -s $i ${binary} &&\
            tput init"
done
