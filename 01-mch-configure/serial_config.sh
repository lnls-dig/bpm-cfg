#!/bin/bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source RFFE mapping IPs
. ${SCRIPTPATH}/../misc/functions.sh

exec_cmd "TRACE" echo "Installing needed packages..."
sudo apt-get install -y cu expect tftpd-hpa tftp
exec_cmd "TRACE" echo "Success!"

exec_cmd "TRACE" echo "Adding your user ($USER) to the dialout group (so cu can access the serial ports)..."
sudo adduser $USER dialout
exec_cmd "TRACE" echo "Success!"

exec_cmd "TRACE" echo "Setting up the TFTP server..."
sudo sed -i 's/\":69\"/\"0.0.0.0:69\"/' /etc/default/tftpd-hpa
sudo cp ${SCRIPTPATH}/mch_clk_cfg.txt /var/lib/tftpboot/
sudo service tftpd-hpa restart
exec_cmd "TRACE" echo "Success!"

exec_cmd "TRACE" echo "Testing if the TFTP server is up..."
tftp localhost << EOF
get mch_clk_cfg.txt test.txt
quit
EOF

if [ -e test.txt ]
then
    if cmp -s "test.txt" "mch_clk_cfg.txt"
    then
        exec_cmd "INFO " echo "TFTP transfer was successful!"
    fi
    rm test.txt
else
    exec_cmd "ERR  " echo "TFTP transfer failed!"
fi

exec_cmd "INFO " echo "You have to log out and in again from this terminal for changes to take effect!"
