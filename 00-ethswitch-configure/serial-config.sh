#!/bin/bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source msic functions
. ${SCRIPTPATH}/../misc/functions.sh

# Check if we already have the packages
if ! [[ $(which cu) ]] || ! [[ $(which expect) ]] || \
    ! [[ $(which tftp) ]] || ! [ -d /var/lib/tftpboot ]; then
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

if ! [[ $(which tftp) ]] ; then
    PACKS+=("tftp")
fi

if ! [ -d /var/lib/tftpboot ]; then
    PACKS+=("tftpd-hpa")
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

exec_cmd "TRACE" echo "Setting up the TFTP server..."
sudo sed -i 's/\":69\"/\"0.0.0.0:69\"/' /etc/default/tftpd-hpa
# Copy Switch configuration
sudo cp ${SCRIPTPATH}/config-switch-dig /var/lib/tftpboot/
# Restart TFTP
sudo service tftpd-hpa restart
exec_cmd "TRACE" echo "Success!"

exec_cmd "TRACE" echo "Testing if the TFTP server is up..."
tftp localhost << EOF
get config-switch-dig test-switch.txt
quit
EOF

if [ -e test-switch.txt ]
then
    if cmp -s "test-switch.txt" "config-switch-dig"
    then
        exec_cmd "INFO " echo "TFTP transfer was successful!"
    fi
    rm test-switch.txt
else
    exec_cmd "ERR  " echo "TFTP transfer failed!"
fi

exec_cmd "INFO " echo "TFTP successfully configured"
