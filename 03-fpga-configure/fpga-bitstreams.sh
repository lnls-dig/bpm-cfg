#!/usr/bin/env bash

############################
# BPM
############################
BPM_URL_RELEASE_BASE="https://github.com/lnls-dig/bpm-gw/releases/download"
BPM_TAG_VERSION="v1.1.1"

# Bitstream name without the extension!
FPGA_BO_BITSTREAM="afcv3-bpm-gw-fmc250m-bo-sirius-v1.1.1-20180302-91ebf0c889"
FPGA_SR_BITSTREAM="afcv3-bpm-gw-fmc250m-sr-sirius-v1.1.1-20180302-91ebf0c889"
FPGA_PBPM_BITSTREAM="afcv3-pbpm-gw-fmcpico1m-v1.1.1-20180302-91ebf0c889"

URL_FPGA_BO_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_BO_BITSTREAM}
URL_FPGA_SR_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_SR_BITSTREAM}
URL_FPGA_PBPM_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_PBPM_BITSTREAM}

############################
# Timing
############################
TIMING_URL_RELEASE_BASE="tim-url-test"
TIMING_TAG_VERSION="vtim-test"

# Bitstream name without the extension!
FPGA_TIMING_BITSTREAM="afcv3-timing"

#URL_FPGA_TIMING_BITSTREAM=${TIMING_URL_RELEASE_BASE}/${TIMING_TAG_VERSION}/${FPGA_TIMING_BITSTREAM}
# Keep this empty until we have the timing bitstream available
URL_FPGA_TIMING_BITSTREAM=""

############################
# All FPGA Bitstreams
############################
# Keep them synched!
URL_FPGA_ALL=(${URL_FPGA_BO_BITSTREAM}
            ${URL_FPGA_SR_BITSTREAM}
            ${URL_FPGA_PBPM_BITSTREAM}
            ${URL_FPGA_TIMING_BITSTREAM})
FPGA_BITSTREAMS_ALL=(${FPGA_BO_BITSTREAM}
                    ${FPGA_SR_BITSTREAM}
                    ${FPGA_PBPM_BITSTREAM}
                    ${FPGA_TIMING_BITSTREAM})
