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
                ERRS[\${board}]=\${board}
            fi
        done && \
        if [[ \"\${ERRS[@]}\" ]]; then \
            echo \"ERROR: Boards \${ERRS[@]} do not have PCIe link\"
        else
            echo \"SUCCESS: All boards have PCIe Link\"
        fi \
    "
