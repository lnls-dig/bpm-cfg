#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

IP="$1"
SSHPASS_USR="$2"
shift 2
BOARD_NUMBERS=("$@")

# Login via SSH and check CPU
SSHPASS="${SSHPASS_USR}" sshpass -e \
    ssh -o StrictHostKeyChecking=no \
    root@${IP} \
    bash -c "\
        true && \
        for board in "${BOARD_NUMBERS[@]}"; do \
            if [[ \$(ls /dev | grep fpga-\${board}) ]]; then \
                echo \"Board number \${board} PCIe Link: YES\"
            else \
                echo \"Board number \${board} PCIe Link: NO\"
                echo \"Board \${board} does not have PCIe Link\"
                exit 1;
            fi
        done && \
        echo \"All boards have PCIe Link\" \
    "
