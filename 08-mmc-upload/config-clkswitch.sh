#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source FPGA mapping
. ${SCRIPTPATH}/../misc/crate-fpga-mapping.sh

# Source common functions
. ${SCRIPTPATH}/../misc/functions.sh

set +u

# Simple argument checking
if [ $# -lt 1 ]; then
    echo "Usage: ./config-clkswitch.sh <Crate Number>"
    exit 1
fi
CRATE_NUMBER="$1"

set -u

# Get the crate ip from crate-fpga-mapping.sh using the crate number
crate_ip_raw="BPM_CRATE_${CRATE_NUMBER}_MCH_HOSTNAME"
crate_ip=${!crate_ip_raw}

set +e

#Program clocks switches
exec_cmd "INFO " echo "Programming Clock Switches..."
for slot in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do

    bpm_crate_fpga_raw="BPM_CRATE_${CRATE_NUMBER}_FPGA[${slot}]"
    bpm_crate_fpga=${!bpm_crate_fpga_raw}

    case ${bpm_crate_fpga} in
        "timing")
            clk_cfg="0x20 0x20 0x20 0xAF 0xAF 0x28 0xAD 0x28 0xA8 0x2D 0x2E 0x2E 0x2E 0xAF 0x2E 0x23"
        ;;
        "fofb")
            clk_cfg="0xAA 0x20 0x20 0x20 0x20 0x60 0x20 0xAA 0x20 0x20 0x60 0x20 0x20 0xA5 0x20 0xAA"
        ;;
        "pbpm")
            clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
        ;;
        "sr")
            clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
        ;;
        "bo")
            clk_cfg="0x20 0x20 0x20 0x20 0xAD 0x28 0xA5 0xAF 0xA8 0x25 0xA5 0xA5 0x2E 0xA5 0xA5 0xA5"
        ;;
        "")
            # Skip it
            continue
        ;;
        *)
            exec_cmd "ERR  " echo "Invalid bitstream type: ${bpm_crate_fpga}" >&2
            exit 1
        ;;
    esac
    ipmitool -I lan -H ${crate_ip} -A  none -T 0x82 -m 0x20 -t $((112 + 2*${slot})) raw 0x32 0x03 ${clk_cfg}
    if [[ $? != 0 ]]; then
        echo "Clock configuration failed! Slot ${slot} Crate ${crate_ip}"
        exit 1
    fi
    echo "Clock Switch configurated! Slot ${slot}"
done

exec_cmd "INFO " echo "Clock Switch Configuration Done :)"
