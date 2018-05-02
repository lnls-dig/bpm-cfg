#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

IP="$1"
SSHPASS_USR="$2"

# Login via SSH and check CPU
SSHPASS="${SSHPASS_USR}" sshpass -e \
    ssh -o StrictHostKeyChecking=no \
    root@${IP} \
    bash -c "\
        true && \
        $(typeset -f exec_cmd);
        COMMAND=\$(cat /proc/meminfo | grep \"MemTotal: *16[0-9]\\{6\\} kB\")
        if [[ \${COMMAND} ]]; then \
            exec_cmd \"INFO \" echo \"CPU has 16GB RAM memory\"
        else
            exec_cmd \"ERR  \" echo \"CPU does NOT have 16GB RAM memory\"
        fi \
    "
