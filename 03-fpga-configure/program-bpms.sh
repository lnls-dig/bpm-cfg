#!/bin/bash

# This is a simple example to show how to program multiple boards
# using the vivado-prog.py script. It does not aim to be generic,
# but to provide a starting point for more complex scripts

set -euo pipefail

MCH_IP=$1
# This must follow the format "<port_number>,<bitstream_name_without_extension>"
PORT_BITSTREAM="$2"

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

BIT_EXTENSION=.bit
MCS_EXTENSION=.mcs

for portbit in ${PORT_BITSTREAM[*]}; do
    OLDIFS=$IFS; IFS=',';
    # Separate "tuple" arguments with positional notation
    set -- ${portbit};
    port=$1
    bitstream_raw=$2

    if [ "${bitstream_raw}" ]; then
        echo "Programming AFC located in port: "${port}

        # Bitstream/MCS names
        bitstream_bit=${bitstream_raw}${BIT_EXTENSION}
        bitstream_mcs=${bitstream_raw}${MCS_EXTENSION}

        echo "Using bitstream: " ${bitstream_bit}
        echo "Using mcs: " ${bitstream_mcs}

        bash -c "\
            cd ${SCRIPTPATH}/../foreign/fpga-programming/ && \
            time ./vivado-prog.py \
            --bit_to_mcs \
            --bit=${bitstream_bit} \
            --mcs=${bitstream_mcs} \
            --svf=./afc-scansta.svf \
            --prog_flash \
            --host_url=${MCH_IP}:${port} \
        "
    fi

    IFS=$OLDIFS;
done;
