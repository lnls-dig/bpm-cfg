## Deploy instructions

### {afc-timing,bpm,fofb}-gw

1. Clone [bpm-cfg](https://github.com/lnls-dig/bpm-cfg).
2. Create a folder named `bitstreams` inside `04-fpga-configure` and copy all
   nsvf files into it.
3. In `04-fpga-configure/fpga-bitstreams.sh`, fill `FPGA_BO_BITSTREAM`,
   `FPGA_SR_BITSTREAM`, `FPGA_PBPM_BITSTREAM`, `FPGA_FOFB_BITSTREAM` and
   `FPGA_TIMING_BITSTREAM` variables with the corresponding nsvf file names
   without .nsvf extension.
4. In `misc/crate-fpga-mapping.sh` one can see the current mapping between
   crates' slots and target gw. Edit this file setting `""` to those slots that
   won't be updated.
5. Run `04-fpga-configure/program-all.sh`.
