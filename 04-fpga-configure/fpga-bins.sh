#!/usr/bin/env bash

# NOTE: These variables should contain the absolute path to the .bit
# or .bin file. Writting to the FPGA volatile configuration or flash
# memory will be decided based on the file extension (.bit ->
# volatile, .bin -> flash).

############################
# Timing
############################
FPGA_TIMING_BIN=""

############################
# FOFB
############################
FPGA_FOFB_BIN=""

############################
# BPM
############################
FPGA_PBPM_BIN=""
FPGA_SR_BIN=""
FPGA_BO_BIN=""
