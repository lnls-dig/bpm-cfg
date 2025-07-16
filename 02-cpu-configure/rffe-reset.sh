#!/bin/sh

set -eu
if [ $# -ne 1 ]; then
    echo "Usage: $0 <virtual_slot>"
    exit 1
fi

expect << EOF
spawn telnet 192.168.2.$(( 190 + $1 ))
expect "nsh>"
send "reboot\r"
EOF
