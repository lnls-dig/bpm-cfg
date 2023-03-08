#!/usr/bin/env bash

############################
# BPM
############################
BPM_URL_RELEASE_BASE="https://github.com/lnls-dig/bpm-gw/releases/download"
BPM_TAG_VERSION="v2.3.0"

# NSVF files
FPGA_BO_BITSTREAM="afcv3-bpm-gw-fmc250m-bo-sirius-v2.3.0-20190404-f6e88ce5be.nvsf"
FPGA_SR_BITSTREAM="afcv3-bpm-gw-fmc250m-sr-sirius-v2.3.0-20190404-f6e88ce5be.nvsf"
FPGA_PBPM_BITSTREAM="afcv3-pbpm-gw-fmcpico1m-v2.3.0-20190404-f6e88ce5be.nsvf"

URL_FPGA_BO_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_BO_BITSTREAM}
URL_FPGA_SR_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_SR_BITSTREAM}
URL_FPGA_PBPM_BITSTREAM=${BPM_URL_RELEASE_BASE}/${BPM_TAG_VERSION}/${FPGA_PBPM_BITSTREAM}

############################
# FOFB
############################
FOFB_URL_RELEASE_BASE=""
FOFB_TAG_VERSION=""

# NSVF file
FPGA_FOFB_BITSTREAM="afcv4_ref_fofb_ctrl.nsvf"

#URL_FPGA_FOFB_BITSTREAM=${FOFB_URL_RELEASE_BASE}/${FOFB_TAG_VERSION}/${FPGA_FOFB_BITSTREAM}
# Keep this empty until we have the fofb bitstream available
URL_FPGA_FOFB_BITSTREAM=""

############################
# Timing
############################
TIMING_URL_RELEASE_BASE=""
TIMING_TAG_VERSION=""

# NSVF file
FPGA_TIMING_BITSTREAM="afcv3-timing-vx.y.z-X-Y.nsvf"

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
            ${URL_FPGA_FOFB_BITSTREAM}
            ${URL_FPGA_TIMING_BITSTREAM})
FPGA_BITSTREAMS_ALL=(${FPGA_BO_BITSTREAM}
                    ${FPGA_SR_BITSTREAM}
                    ${FPGA_PBPM_BITSTREAM}
                    ${FPGA_FOFB_BITSTREAM}
                    ${FPGA_TIMING_BITSTREAM})
