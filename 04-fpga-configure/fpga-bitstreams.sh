#!/usr/bin/env bash

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
# NSVF file
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
