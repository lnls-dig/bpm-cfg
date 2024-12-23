# BPM configuration scripts

## Instructions

### 0. Run scripts inside 00-ethswitch-configure to configure the Switch

Before running the scripts be sure to have a USB stick with the file
"config-switch-dig" connected in the switch "Aux Port"

    ./00-ethswitch-configure/ethswitch-configure.sh

For example:

    ./00-ethswitch-configure/ethswitch-configure.sh

### 1. Run scripts inside 01-mch-configure to configure the MCH

    ./01-mch-configure/mch-configure.sh <Connection Type> [<MCH IP> <MCH Password>] <TFTP server address> <Crate Number>

For example, for a serial connection, with TFTP server in 10.0.17.38 and Crate Number 9:

    ./01-mch-configure/mch-configure.sh serial 10.0.17.38 9

### 2. Run scripts inside 02-cpu-configure to configure the CPU

    ./02-cpu-configure/cpu-configure.sh <CPU IP> <Crate Number> <CPU Root password>

For example:

    ./02-cpu-configure/cpu-configure.sh 10.0.18.55 9 root-pass

### 3. Run scripts inside 03-mmc-upload to configure the MMCs firmware

Before running the script, be sure to have the desired firmware in an `binaries` directory (./3-mmc-upload/binaries)
    ./03-mmc-upload/mmc-upload.sh <Crate Number> <OpenMMC Version>

For example:

    ./03-mmc-upload/mmc-upload.sh 1 v1.5.1


### 4. Run scripts inside 04-fpga-configure to configure the FPGAs

    ./04-fpga-configure/fpga-configure.sh <MCH IP> <Crate Number>

For example:

    ./04-fpga-configure/fpga-configure.sh 10.0.18.60 9

### 5. Run script inside 05-cpu-check to check CPU status

    ./05-cpu-check/cpu-check.sh <CPU IP> <Crate Number> <CPU Root password>

For example, for testing the link of boards in crate 9:

    ./05-cpu-check/cpu-check.sh 10.0.18.55 9 root-pass

### 6. Run script inside 06-bpm-test to test BPMs

    ./06-bpm-test/bpm-tests.sh <Crate Number> <Destination folder for test results>

For example, for testing the bpm in crate 9:

    ./06-bpm-test/bpm-tests.sh 9 ~/results_test_no_signal
