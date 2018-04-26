#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source RFFE mapping IPs

set +u

# Simple argument checking
if [ $# -lt 2 ]; then
    echo "Usage: ./bpm-tests.sh <Crate Number> <Destination folder for test results>"
    exit 1
fi

CRATE_NUMBER_="$1"
# Remove leading zeros
CRATE_NUMBER="$(echo ${CRATE_NUMBER_} | sed 's/^0*//')"
TEST_RESULT_FOLDER="$2"

set -u

# Check if repo was cloned with fpga-programming submodule
[ ! -z "$(ls -A "${SCRIPTPATH}/../foreign/bpm-tests")" ] || \
    git submodule update --init

${SCRIPTPATH}/../foreign/bpm-tests/site_specific/sirius/tests/test_no_signal.m ${CRATE_NUMBER} ${TEST_RESULT_FOLDER}
