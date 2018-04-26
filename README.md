# BPM configuration scripts

## Instructions

### 1. Run scripts inside 01-mch-configure to configure the MCH

    ./01-mch-configure/mch-configure.sh <Connection Type> [<MCH IP> <MCH Password>] <TFTP server address> <MCH Hostname Suffix>]

For example, for a serial connection, with TFTP server in 10.0.17.38 and MCH Hostanem suffix 09:

    ./01-mch-configure/mch-configure.sh serial 10.0.17.38 09

### 2. Run scripts inside 02-cpu-configure to configure the CPU

    ./02-cpu-configure/cpu-configure.sh <CPU IP> <Hostname Suffix> <Crate Number> <CPU Root password>

For example:

    ./02-cpu-configure/cpu-configure.sh 10.0.18.55 09 9 root-pass

### 3. Run scripts inside 03-fpga-configure to configure the FPGAs

    ./03-fpga-configure/fpga-configure.sh <MCH IP> <Crate Number>

For example:

    ./03-fpga-configure/fpga-configure.sh 10.0.18.60 9

### 4. Run script inside 04-cpu-check to check CPU status

    ./04-cpu-check/cpu-check.sh <CPU IP> <Crate Number> <CPU Root password>

For example, for testing the link of boards in crate 9:

    ./04-cpu-check/cpu-check.sh 10.0.18.55 9 root-pass

### 5. Run script inside 05-bpm-test to test BPMs

    ./05-bpm-test/bpm-tests.sh <Crate Number> <Destination folder for test results>

For example, for testing the bpm in crate 9:

    ./05-bpm-test/bpm-tests.sh 9 ~/results_test_no_signal
