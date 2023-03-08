#!/bin/bash

# This is a simple example to show how to program multiple boards
# using the vivado-prog.py script. It does not aim to be generic,
# but to provide a starting point for more complex scripts

set -euxo pipefail

MCH_IP=$1
# This must follow the format "<bitstream>,<nsvf slot>"
PORT_BITSTREAM="$2"

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

for portbit in ${PORT_BITSTREAM[*]}; do
    OLDIFS=$IFS; IFS=',';
    # Separate "tuple" arguments with positional notation
    set -- ${portbit};
    bitstream=$1
    nsvf_slot=$2

    if [ "${bitstream}" ]; then
        echo "Programming AFC located in slot nsvf: " ${nsvf_slot}

        echo "Using nsvf: " ${bitstream}

        curl \
        -H "Content-Type: multipart/form-data" \
        -F "XsvfReqTarget=${nsvf_slot}" \
        -F "XsvfReqFreq=9" \
        -F "filename=@${bitstream}" \
        -X POST \
        -u "root":"nat" \
        "http://${MCH_IP}/goform/ctrl_svf_proc" && \
            echo "Programming has successfully completed." || \
            echo "Programming has failed."
    fi

    IFS=$OLDIFS;
done;
