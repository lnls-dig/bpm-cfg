#!/bin/bash

# This is a simple example to show how to program multiple boards
# using the vivado-prog.py script. It does not aim to be generic,
# but to provide a starting point for more complex scripts

set -euxo pipefail

MCH_IP=$1
# This must follow the format "<port_number>,<bitstream_name_without_extension>"
PORT_BITSTREAM="$2"
CRATE_NUMBER="$3"

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

NSVF_EXTENSION=.nsvf

for portbit in ${PORT_BITSTREAM[*]}; do
    OLDIFS=$IFS; IFS=',';
    # Separate "tuple" arguments with positional notation
    set -- ${portbit};
    port=$1
    bitstream_raw=$2
    slot_nsvf=$3

    if [ "${bitstream_raw}" ]; then
        echo "Programming AFC located in port: " ${port}
        echo "Programming AFC located in slot nsvf: " ${slot_nsvf}

        bitstream_nsvf=${bitstream_raw}${NSVF_EXTENSION}

        echo "Using nsvf: " ${bitstream_nsvf}

        curl \
        -H "Content-Type: multipart/form-data" \
        -F "XsvfReqTarget=${slot_nsvf}" \
        -F "XsvfReqFreq=9" \
        -F "filename=@${bitstream_nsvf}" \
        -X POST \
        -u "root":"nat" \
        "http://${MCH_IP}/goform/ctrl_svf_proc" && \
            echo "Programming has successfully completed." || \
            echo "Programming has failed."
    fi

    IFS=$OLDIFS;
done;
