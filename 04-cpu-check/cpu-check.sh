#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

IP="$1"
BOARD_NUMBER="$2"
SSHPASS_USR="$3"

# Login via SSH and check CPU
SSHPASS="${SSHPASS_USR}" sshpass -e \
    ssh -o StrictHostKeyChecking=no \
    root@${IP} \
    bash -c "\
        true && \
        if [[ \$(ls /dev | grep fpga-${BOARD_NUMBER}) ]]; then \
            echo \"Board number ${BOARD_NUMBER} PCIe Link: YES\"
        else \
            echo \"Board number ${BOARD_NUMBER} PCIe Link: NO\"
        fi \
    "
