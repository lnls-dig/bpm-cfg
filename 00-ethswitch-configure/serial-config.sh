#!/bin/bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source msic functions
. ${SCRIPTPATH}/../misc/functions.sh

# Check if we already have the packages
if ! [[ $(which cu) ]] || ! [[ $(which expect) ]]; then
    UPDATE_CMD="apt-get update"
fi

PACKS=()
INSTALL_CMD="apt-get install -y"
# Install each one of the missing ones
if ! [[ $(which cu) ]] ; then
    PACKS+=("cu")
fi

if ! [[ $(which expect) ]] ; then
    PACKS+=("expect")
fi

# Update cache if needed
if [ -v UPDATE_CMD ]; then
    exec_cmd "TRACE" echo "Updating cache..."
    sudo ${UPDATE_CMD}
    exec_cmd "TRACE" echo "Success!"
fi

# Install packages if needed
if [ -v PACKS ]; then
    exec_cmd "TRACE" echo "Installing needed packages..."
    sudo ${INSTALL_CMD} "${PACKS[@]}"
    exec_cmd "TRACE" echo "Success!"
fi


exec_cmd "TRACE" echo "Adding your user ($USER) to the dialout group (so cu can access the serial ports)..."
sudo adduser $USER dialout
exec_cmd "TRACE" echo "Success!"

exec_cmd "INFO " echo "Serial successfully configured"
