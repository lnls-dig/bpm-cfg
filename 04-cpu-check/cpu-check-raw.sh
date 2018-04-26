#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

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
        $(typeset -f exec_cmd);
        for board in "${BOARD_NUMBERS[@]}"; do \
            if [[ \$(ls /dev | grep fpga-\${board}) ]]; then \
                exec_cmd \"INFO \" echo \"Board number \${board} PCIe Link: YES\"
            else \
                exec_cmd \"ERR  \" echo \"Board number \${board} PCIe Link: NO\"
                ERRS[\${board}]=\${board}
            fi
        done && \
        if [[ \"\${ERRS[@]}\" ]]; then \
            exec_cmd \"ERR  \" echo \"Board(s) \${ERRS[@]} do not have PCIe link\"
        else
            exec_cmd \"INFO \" echo \"All boards have PCIe Link\"
        fi \
    "
