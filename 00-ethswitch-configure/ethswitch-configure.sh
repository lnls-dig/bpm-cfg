#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

exec_cmd "INFO " echo "Setting up Serial connection..."

# Call actual serial config
${SCRIPTPATH}/serial-config.sh

exec_cmd "INFO " echo "Configuring Switch..."

# Call actual switch config script
${SCRIPTPATH}/ethswitch-config.exp
