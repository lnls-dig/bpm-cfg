#!/usr/bin/env bash

declare -a BPM_CRATE_1_FPGA
declare -a BPM_CRATE_2_FPGA
declare -a BPM_CRATE_3_FPGA
declare -a BPM_CRATE_4_FPGA
declare -a BPM_CRATE_5_FPGA
declare -a BPM_CRATE_6_FPGA
declare -a BPM_CRATE_7_FPGA
declare -a BPM_CRATE_8_FPGA
declare -a BPM_CRATE_9_FPGA
declare -a BPM_CRATE_10_FPGA
declare -a BPM_CRATE_11_FPGA
declare -a BPM_CRATE_12_FPGA
declare -a BPM_CRATE_13_FPGA
declare -a BPM_CRATE_14_FPGA
declare -a BPM_CRATE_15_FPGA
declare -a BPM_CRATE_16_FPGA
declare -a BPM_CRATE_17_FPGA
declare -a BPM_CRATE_18_FPGA
declare -a BPM_CRATE_19_FPGA
declare -a BPM_CRATE_20_FPGA
declare -a BPM_CRATE_21_FPGA
declare -a BPM_CRATE_22_FPGA

# Crate 1 FPGA bitstreams definitions
BPM_CRATE_1_FPGA[1]="timing"
BPM_CRATE_1_FPGA[2]=""
BPM_CRATE_1_FPGA[3]=""
BPM_CRATE_1_FPGA[4]=""
BPM_CRATE_1_FPGA[5]=""
BPM_CRATE_1_FPGA[6]=""
BPM_CRATE_1_FPGA[7]="sr"
BPM_CRATE_1_FPGA[8]="sr"
BPM_CRATE_1_FPGA[9]="sr"
BPM_CRATE_1_FPGA[10]="sr"
BPM_CRATE_1_FPGA[11]="bo"
BPM_CRATE_1_FPGA[12]=""

BPM_CRATE_1_CPU_HOSTNAME="cpu-bpm-01"
BPM_CRATE_1_MCH_HOSTNAME="mch-bpm-01"

# Crate 2 FPGA bitstreams definitions
BPM_CRATE_2_FPGA[1]="timing"
BPM_CRATE_2_FPGA[2]=""
BPM_CRATE_2_FPGA[3]=""
BPM_CRATE_2_FPGA[4]=""
BPM_CRATE_2_FPGA[5]=""
BPM_CRATE_2_FPGA[6]=""
BPM_CRATE_2_FPGA[7]="sr"
BPM_CRATE_2_FPGA[8]="sr"
BPM_CRATE_2_FPGA[9]="sr"
BPM_CRATE_2_FPGA[10]="sr"
BPM_CRATE_2_FPGA[11]="bo"
BPM_CRATE_2_FPGA[12]="bo"

BPM_CRATE_2_CPU_HOSTNAME="cpu-bpm-02"
BPM_CRATE_2_MCH_HOSTNAME="mch-bpm-02"

# Crate 3 FPGA bitstreams definitions
BPM_CRATE_3_FPGA[1]="timing"
BPM_CRATE_3_FPGA[2]=""
BPM_CRATE_3_FPGA[3]=""
BPM_CRATE_3_FPGA[4]=""
BPM_CRATE_3_FPGA[5]=""
BPM_CRATE_3_FPGA[6]=""
BPM_CRATE_3_FPGA[7]="sr"
BPM_CRATE_3_FPGA[8]="sr"
BPM_CRATE_3_FPGA[9]="sr"
BPM_CRATE_3_FPGA[10]="sr"
BPM_CRATE_3_FPGA[11]="bo"
BPM_CRATE_3_FPGA[12]=""

BPM_CRATE_3_CPU_HOSTNAME="cpu-bpm-03"
BPM_CRATE_3_MCH_HOSTNAME="mch-bpm-03"

# Crate 4 FPGA bitstreams definitions
BPM_CRATE_4_FPGA[1]="timing"
BPM_CRATE_4_FPGA[2]=""
BPM_CRATE_4_FPGA[3]=""
BPM_CRATE_4_FPGA[4]=""
BPM_CRATE_4_FPGA[5]=""
BPM_CRATE_4_FPGA[6]=""
BPM_CRATE_4_FPGA[7]="sr"
BPM_CRATE_4_FPGA[8]="sr"
BPM_CRATE_4_FPGA[9]="sr"
BPM_CRATE_4_FPGA[10]="sr"
BPM_CRATE_4_FPGA[11]="bo"
BPM_CRATE_4_FPGA[12]="bo"

BPM_CRATE_4_CPU_HOSTNAME="cpu-bpm-04"
BPM_CRATE_4_MCH_HOSTNAME="mch-bpm-04"

# Crate 5 FPGA bitstreams definitions
BPM_CRATE_5_FPGA[1]="timing"
BPM_CRATE_5_FPGA[2]=""
BPM_CRATE_5_FPGA[3]=""
BPM_CRATE_5_FPGA[4]=""
BPM_CRATE_5_FPGA[5]=""
BPM_CRATE_5_FPGA[6]=""
BPM_CRATE_5_FPGA[7]="sr"
BPM_CRATE_5_FPGA[8]="sr"
BPM_CRATE_5_FPGA[9]="sr"
BPM_CRATE_5_FPGA[10]="sr"
BPM_CRATE_5_FPGA[11]="bo"
BPM_CRATE_5_FPGA[12]=""

BPM_CRATE_5_CPU_HOSTNAME="cpu-bpm-05"
BPM_CRATE_5_MCH_HOSTNAME="mch-bpm-05"

# Crate 6 FPGA bitstreams definitions
BPM_CRATE_6_FPGA[1]="timing"
BPM_CRATE_6_FPGA[2]=""
BPM_CRATE_6_FPGA[3]=""
BPM_CRATE_6_FPGA[4]="pbpm"
BPM_CRATE_6_FPGA[5]=""
BPM_CRATE_6_FPGA[6]="sr"
BPM_CRATE_6_FPGA[7]="sr"
BPM_CRATE_6_FPGA[8]="sr"
BPM_CRATE_6_FPGA[9]="sr"
BPM_CRATE_6_FPGA[10]="sr"
BPM_CRATE_6_FPGA[11]="bo"
BPM_CRATE_6_FPGA[12]="bo"

BPM_CRATE_6_CPU_HOSTNAME="cpu-bpm-06"
BPM_CRATE_6_MCH_HOSTNAME="mch-bpm-06"

# Crate 7 FPGA bitstreams definitions
BPM_CRATE_7_FPGA[1]="timing"
BPM_CRATE_7_FPGA[2]=""
BPM_CRATE_7_FPGA[3]=""
BPM_CRATE_7_FPGA[4]="pbpm"
BPM_CRATE_7_FPGA[5]=""
BPM_CRATE_7_FPGA[6]="sr"
BPM_CRATE_7_FPGA[7]="sr"
BPM_CRATE_7_FPGA[8]="sr"
BPM_CRATE_7_FPGA[9]="sr"
BPM_CRATE_7_FPGA[10]="sr"
BPM_CRATE_7_FPGA[11]="bo"
BPM_CRATE_7_FPGA[12]=""

BPM_CRATE_7_CPU_HOSTNAME="cpu-bpm-07"
BPM_CRATE_7_MCH_HOSTNAME="mch-bpm-07"

# Crate 8 FPGA bitstreams definitions
BPM_CRATE_8_FPGA[1]="timing"
BPM_CRATE_8_FPGA[2]=""
BPM_CRATE_8_FPGA[3]=""
BPM_CRATE_8_FPGA[4]="pbpm"
BPM_CRATE_8_FPGA[5]=""
BPM_CRATE_8_FPGA[6]="sr"
BPM_CRATE_8_FPGA[7]="sr"
BPM_CRATE_8_FPGA[8]="sr"
BPM_CRATE_8_FPGA[9]="sr"
BPM_CRATE_8_FPGA[10]="sr"
BPM_CRATE_8_FPGA[11]="bo"
BPM_CRATE_8_FPGA[12]="bo"

BPM_CRATE_8_CPU_HOSTNAME="cpu-bpm-08"
BPM_CRATE_8_MCH_HOSTNAME="mch-bpm-08"

# Crate 9 FPGA bitstreams definitions
BPM_CRATE_9_FPGA[1]="timing"
BPM_CRATE_9_FPGA[2]=""
BPM_CRATE_9_FPGA[3]=""
BPM_CRATE_9_FPGA[4]="pbpm"
BPM_CRATE_9_FPGA[5]=""
BPM_CRATE_9_FPGA[6]="sr"
BPM_CRATE_9_FPGA[7]="sr"
BPM_CRATE_9_FPGA[8]="sr"
BPM_CRATE_9_FPGA[9]="sr"
BPM_CRATE_9_FPGA[10]="sr"
BPM_CRATE_9_FPGA[11]="bo"
BPM_CRATE_9_FPGA[12]=""

BPM_CRATE_9_CPU_HOSTNAME="cpu-bpm-09"
BPM_CRATE_9_MCH_HOSTNAME="mch-bpm-09"

# Crate 10 FPGA bitstreams definitions
BPM_CRATE_10_FPGA[1]="timing"
BPM_CRATE_10_FPGA[2]=""
BPM_CRATE_10_FPGA[3]=""
BPM_CRATE_10_FPGA[4]=""
BPM_CRATE_10_FPGA[5]="pbpm"
BPM_CRATE_10_FPGA[6]=""
BPM_CRATE_10_FPGA[7]="sr"
BPM_CRATE_10_FPGA[8]="sr"
BPM_CRATE_10_FPGA[9]="sr"
BPM_CRATE_10_FPGA[10]="sr"
BPM_CRATE_10_FPGA[11]="bo"
BPM_CRATE_10_FPGA[12]="bo"

BPM_CRATE_10_CPU_HOSTNAME="cpu-bpm-10"
BPM_CRATE_10_MCH_HOSTNAME="mch-bpm-10"

# Crate 11 FPGA bitstreams definitions
BPM_CRATE_11_FPGA[1]="timing"
BPM_CRATE_11_FPGA[2]=""
BPM_CRATE_11_FPGA[3]=""
BPM_CRATE_11_FPGA[4]="pbpm"
BPM_CRATE_11_FPGA[5]=""
BPM_CRATE_11_FPGA[6]="sr"
BPM_CRATE_11_FPGA[7]="sr"
BPM_CRATE_11_FPGA[8]="sr"
BPM_CRATE_11_FPGA[9]="sr"
BPM_CRATE_11_FPGA[10]="sr"
BPM_CRATE_11_FPGA[11]="bo"
BPM_CRATE_11_FPGA[12]=""

BPM_CRATE_11_CPU_HOSTNAME="cpu-bpm-11"
BPM_CRATE_11_MCH_HOSTNAME="mch-bpm-11"

# Crate 12 FPGA bitstreams definitions
BPM_CRATE_12_FPGA[1]="timing"
BPM_CRATE_12_FPGA[2]=""
BPM_CRATE_12_FPGA[3]=""
BPM_CRATE_12_FPGA[4]="pbpm"
BPM_CRATE_12_FPGA[5]="pbpm"
BPM_CRATE_12_FPGA[6]="sr"
BPM_CRATE_12_FPGA[7]="sr"
BPM_CRATE_12_FPGA[8]="sr"
BPM_CRATE_12_FPGA[9]="sr"
BPM_CRATE_12_FPGA[10]="sr"
BPM_CRATE_12_FPGA[11]="bo"
BPM_CRATE_12_FPGA[12]="bo"

BPM_CRATE_12_CPU_HOSTNAME="cpu-bpm-12"
BPM_CRATE_12_MCH_HOSTNAME="mch-bpm-12"

# Crate 13 FPGA bitstreams definitions
BPM_CRATE_13_FPGA[1]="timing"
BPM_CRATE_13_FPGA[2]=""
BPM_CRATE_13_FPGA[3]=""
BPM_CRATE_13_FPGA[4]=""
BPM_CRATE_13_FPGA[5]="pbpm"
BPM_CRATE_13_FPGA[6]="sr"
BPM_CRATE_13_FPGA[7]="sr"
BPM_CRATE_13_FPGA[8]="sr"
BPM_CRATE_13_FPGA[9]="sr"
BPM_CRATE_13_FPGA[10]="sr"
BPM_CRATE_13_FPGA[11]="bo"
BPM_CRATE_13_FPGA[12]=""

BPM_CRATE_13_CPU_HOSTNAME="cpu-bpm-13"
BPM_CRATE_13_MCH_HOSTNAME="mch-bpm-13"

# Crate 14 FPGA bitstreams definitions
BPM_CRATE_14_FPGA[1]="timing"
BPM_CRATE_14_FPGA[2]=""
BPM_CRATE_14_FPGA[3]=""
BPM_CRATE_14_FPGA[4]="pbpm"
BPM_CRATE_14_FPGA[5]="pbpm"
BPM_CRATE_14_FPGA[6]="sr"
BPM_CRATE_14_FPGA[7]="sr"
BPM_CRATE_14_FPGA[8]="sr"
BPM_CRATE_14_FPGA[9]="sr"
BPM_CRATE_14_FPGA[10]="sr"
BPM_CRATE_14_FPGA[11]="bo"
BPM_CRATE_14_FPGA[12]="bo"

BPM_CRATE_14_CPU_HOSTNAME="cpu-bpm-14"
BPM_CRATE_14_MCH_HOSTNAME="mch-bpm-14"

# Crate 15 FPGA bitstreams definitions
BPM_CRATE_15_FPGA[1]="timing"
BPM_CRATE_15_FPGA[2]=""
BPM_CRATE_15_FPGA[3]=""
BPM_CRATE_15_FPGA[4]="pbpm"
BPM_CRATE_15_FPGA[5]=""
BPM_CRATE_15_FPGA[6]="sr"
BPM_CRATE_15_FPGA[7]="sr"
BPM_CRATE_15_FPGA[8]="sr"
BPM_CRATE_15_FPGA[9]="sr"
BPM_CRATE_15_FPGA[10]="sr"
BPM_CRATE_15_FPGA[11]="bo"
BPM_CRATE_15_FPGA[12]=""

BPM_CRATE_15_CPU_HOSTNAME="cpu-bpm-15"
BPM_CRATE_15_MCH_HOSTNAME="mch-bpm-15"

# Crate 16 FPGA bitstreams definitions
BPM_CRATE_16_FPGA[1]="timing"
BPM_CRATE_16_FPGA[2]=""
BPM_CRATE_16_FPGA[3]=""
BPM_CRATE_16_FPGA[4]=""
BPM_CRATE_16_FPGA[5]=""
BPM_CRATE_16_FPGA[6]=""
BPM_CRATE_16_FPGA[7]="sr"
BPM_CRATE_16_FPGA[8]="sr"
BPM_CRATE_16_FPGA[9]="sr"
BPM_CRATE_16_FPGA[10]="sr"
BPM_CRATE_16_FPGA[11]="bo"
BPM_CRATE_16_FPGA[12]="bo"

BPM_CRATE_16_CPU_HOSTNAME="cpu-bpm-16"
BPM_CRATE_16_MCH_HOSTNAME="mch-bpm-16"

# Crate 17 FPGA bitstreams definitions
BPM_CRATE_17_FPGA[1]="timing"
BPM_CRATE_17_FPGA[2]=""
BPM_CRATE_17_FPGA[3]=""
BPM_CRATE_17_FPGA[4]=""
BPM_CRATE_17_FPGA[5]=""
BPM_CRATE_17_FPGA[6]=""
BPM_CRATE_17_FPGA[7]="sr"
BPM_CRATE_17_FPGA[8]="sr"
BPM_CRATE_17_FPGA[9]="sr"
BPM_CRATE_17_FPGA[10]="sr"
BPM_CRATE_17_FPGA[11]="bo"
BPM_CRATE_17_FPGA[12]=""

BPM_CRATE_17_CPU_HOSTNAME="cpu-bpm-17"
BPM_CRATE_17_MCH_HOSTNAME="mch-bpm-17"

# Crate 18 FPGA bitstreams definitions
BPM_CRATE_18_FPGA[1]="timing"
BPM_CRATE_18_FPGA[2]=""
BPM_CRATE_18_FPGA[3]=""
BPM_CRATE_18_FPGA[4]=""
BPM_CRATE_18_FPGA[5]=""
BPM_CRATE_18_FPGA[6]=""
BPM_CRATE_18_FPGA[7]="sr"
BPM_CRATE_18_FPGA[8]="sr"
BPM_CRATE_18_FPGA[9]="sr"
BPM_CRATE_18_FPGA[10]="sr"
BPM_CRATE_18_FPGA[11]="bo"
BPM_CRATE_18_FPGA[12]="bo"

BPM_CRATE_18_CPU_HOSTNAME="cpu-bpm-18"
BPM_CRATE_18_MCH_HOSTNAME="mch-bpm-18"

# Crate 19 FPGA bitstreams definitions
BPM_CRATE_19_FPGA[1]="timing"
BPM_CRATE_19_FPGA[2]=""
BPM_CRATE_19_FPGA[3]=""
BPM_CRATE_19_FPGA[4]=""
BPM_CRATE_19_FPGA[5]=""
BPM_CRATE_19_FPGA[6]=""
BPM_CRATE_19_FPGA[7]="sr"
BPM_CRATE_19_FPGA[8]="sr"
BPM_CRATE_19_FPGA[9]="sr"
BPM_CRATE_19_FPGA[10]="sr"
BPM_CRATE_19_FPGA[11]="bo"
BPM_CRATE_19_FPGA[12]=""

BPM_CRATE_19_CPU_HOSTNAME="cpu-bpm-19"
BPM_CRATE_19_MCH_HOSTNAME="mch-bpm-19"

# Crate 20 FPGA bitstreams definitions
BPM_CRATE_20_FPGA[1]="timing"
BPM_CRATE_20_FPGA[2]=""
BPM_CRATE_20_FPGA[3]=""
BPM_CRATE_20_FPGA[4]=""
BPM_CRATE_20_FPGA[5]=""
BPM_CRATE_20_FPGA[6]=""
BPM_CRATE_20_FPGA[7]="sr"
BPM_CRATE_20_FPGA[8]="sr"
BPM_CRATE_20_FPGA[9]="sr"
BPM_CRATE_20_FPGA[10]="sr"
BPM_CRATE_20_FPGA[11]="bo"
BPM_CRATE_20_FPGA[12]="bo"

BPM_CRATE_20_CPU_HOSTNAME="cpu-bpm-20"
BPM_CRATE_20_MCH_HOSTNAME="mch-bpm-20"

# Crate 21 FPGA bitstreams definitions
BPM_CRATE_21_FPGA[1]="timing"
BPM_CRATE_21_FPGA[2]=""
BPM_CRATE_21_FPGA[3]=""
BPM_CRATE_21_FPGA[4]=""
BPM_CRATE_21_FPGA[5]=""
BPM_CRATE_21_FPGA[6]="sr"
BPM_CRATE_21_FPGA[7]="sr"
BPM_CRATE_21_FPGA[8]="sr"
BPM_CRATE_21_FPGA[9]="sr"
BPM_CRATE_21_FPGA[10]="sr"
BPM_CRATE_21_FPGA[11]="sr"
BPM_CRATE_21_FPGA[12]=""

BPM_CRATE_21_CPU_HOSTNAME="cpu-bpm-tl"
BPM_CRATE_21_MCH_HOSTNAME="mch-bpm-tl"

# Crate 22 FPGA bitstreams definitions
BPM_CRATE_22_FPGA[1]="timing"
BPM_CRATE_22_FPGA[2]=""
BPM_CRATE_22_FPGA[3]=""
BPM_CRATE_22_FPGA[4]="pbpm"
BPM_CRATE_22_FPGA[5]="pbpm"
BPM_CRATE_22_FPGA[6]="sr"
BPM_CRATE_22_FPGA[7]="sr"
BPM_CRATE_22_FPGA[8]="sr"
BPM_CRATE_22_FPGA[9]="sr"
BPM_CRATE_22_FPGA[10]="sr"
BPM_CRATE_22_FPGA[11]="bo"
BPM_CRATE_22_FPGA[12]="bo"

BPM_CRATE_22_CPU_HOSTNAME="cpu-bpm-spare"
BPM_CRATE_22_MCH_HOSTNAME="mch-bpm-spare"