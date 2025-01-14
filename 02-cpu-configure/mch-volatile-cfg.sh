#!/bin/sh

set -eu
if [ $# -ne 1 ]; then
    echo "Usage: $0 <MCH_HOSTNAME>"
    exit 1
fi

expect << EOF
spawn telnet $1
expect "Type <?> to see a list of available commands."
send "diag\r"
expect "  \\[ 0\\] : no action \\(unsupported\\)"
send "10\r"
expect "  \\[ 0\\] : no action \\(unsupported\\)"
send "3\r"
expect "Choose RTM device \\(0=local,1=remote\\)  \\(RET=0/0x0\\):"
send "0\r"
expect "Enter address \\(RET=0/0x0\\): "
send "0x1f\r"
expect "Enter data \\(RET=0/0x0\\): "
send "0x21\r"
expect "RTM \\(RET=0/0x0\\): "
send "q\r"
expect "DIAG \\(RET=0/0x0\\): "
send "q\r"

puts "Configuration completed successfully!"
EOF
