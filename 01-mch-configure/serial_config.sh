#!/bin/bash

echo "Installing needed packages..."
sudo apt-get install -y cu expect tftpd-hpa tftp
echo "Success!"

echo "Adding your user ($USER) to the dialout group (so cu can access the serial ports)..."
sudo adduser $USER dialout
echo "Success!"

echo "Setting up the TFTP server..."
sudo sed -i 's/\":69\"/\"0.0.0.0:69\"/' /etc/default/tftpd-hpa
sudo cp mch_clk_cfg.txt /var/lib/tftpboot/
sudo service tftpd-hpa restart
echo "Success!"

echo "Testing if the TFTP server is up..."
tftp localhost << EOF
get mch_clk_cfg.txt test.txt
quit
EOF

if [ -e test.txt ]
then
    if cmp -s "test.txt" "mch_clk_cfg.txt"
    then
        echo "TFTP transfer was successful!"
    fi
    rm test.txt
else
    echo "TFTP transfer failed!"
fi

echo "You have to log out and in again from this terminal for changes to take effect!"
