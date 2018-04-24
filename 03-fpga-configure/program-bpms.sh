#!/bin/bash

# This is a simple example to show how to program multiple boards
# using the vivado-prog.py script. It does not aim to be generic,
# but to provide a starting point for more complex scripts

set -euo pipefail

MCH_IP=$1
# This must follow the format "<port_number>,<bitstream_name_without_extension>"
PORT_BITSTREAM="$2"

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

BIT_EXTENSION=.bit
MCS_EXTENSION=.mcs

for portbit in ${PORT_BITSTREAM[*]}; do
    OLDIFS=$IFS; IFS=',';
    # Separate "tuple" arguments with positional notation
    set -- ${portbit};
    port=$1
    bitstream_raw=$2

    if [ "${bitstream_raw}" ]; then
        exec_cmd "INFO " echo "Programming AFC located in port: "${port}

        # Bitstream/MCS names
        bitstream_bit=${bitstream_raw}${BIT_EXTENSION}
        bitstream_mcs=${bitstream_raw}${MCS_EXTENSION}

        exec_cmd "INFO " echo "Using bitstream: " ${bitstream_bit}
        exec_cmd "INFO " echo "Using mcs: " ${bitstream_mcs}

        bash -c "\
            SCRIPTPATH=\"\$( cd \"\$( dirname ${BASH_SOURCE[0]}  )\" && pwd  )\" && \
            . \${SCRIPTPATH}/../misc/functions.sh && \
            cd \${SCRIPTPATH}/../foreign/fpga-programming/ && \
            time ./vivado-prog.py \
            --bit_to_mcs \
            --bit=${bitstream_bit} \
            --mcs=${bitstream_mcs} \
            --svf=./afc-scansta.svf \
            --prog_flash \
            --host_url=${MCH_IP}:${port}; \
            if [ \$? -eq 0 ]; then
                exec_cmd \"INFO \" echo \"FPGA gateware successfully programmed\"
            else
                exec_cmd \"ERR  \" echo \"FPGA gateware programming error!\"
            fi
        "
    fi

    IFS=$OLDIFS;
done;
