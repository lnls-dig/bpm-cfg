#!/usr/bin/env bash

# NOTE: These variables should contain the absolute path to the BIN/NSVF file.

############################
# BPM
############################
# NSVF files
FPGA_BO_BITSTREAM=""
FPGA_SR_BITSTREAM=""
FPGA_PBPM_BITSTREAM=""

############################
# FOFB
############################
# BIN file
FPGA_FOFB_BITSTREAM=""

############################
# Timing
############################
# NSVF file
FPGA_TIMING_BITSTREAM=""

############################
# All FPGA Bitstreams
############################
FPGA_BITSTREAMS_ALL=(${FPGA_BO_BITSTREAM}
                    ${FPGA_SR_BITSTREAM}
                    ${FPGA_PBPM_BITSTREAM}
                    ${FPGA_FOFB_BITSTREAM}
                    ${FPGA_TIMING_BITSTREAM})
