#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 1 ]; then
    echo "Usage: ./ethswitch-configure.sh <FTP Server Address>"
    exit 1
fi

TFTP_IPADDR="$1"

set -u

exec_cmd "INFO " echo "Setting up TFTP server..."

# Call actual serial config
${SCRIPTPATH}/serial-config.sh

exec_cmd "INFO " echo "Configuring Switch..."

# Call actual switch config script
${SCRIPTPATH}/ethswitch-config.exp ${TFTP_IPADDR}
