# BPM configuration scripts

## Instructions

### 1. Run scripts inside 01-mch-configure to configure the MCH

### 2. Run scripts inside 02-cpu-configure to configure the CPU

    ./02-cpu-configure/cpu-configure.sh <CPU IP> <Hostname Suffix> <Crate Number> <CPU Root password>

For example:

    ./02-cpu-configure/cpu-configure.sh 10.0.18.55 09 9 root-pass

### 3. Run scripts inside 03-fpga-configure to configure the FPGAs

    ./03-fpga-configure/fpga-configure.sh <MCH IP> <Crate Number>

For example:

    ./03-fpga-configure/fpga-configure.sh 10.0.18.60 9

### 4. Run script inside 04-cpu-check to check CPU status

    ./04-cpu-check/cpu-check.sh <CPU IP> <CPU Root password> <Crate Number>

For example, for testing the link of boards in crate 3:

    ./04-cpu-check/cpu-check.sh 10.0.18.55 root-pass 3
