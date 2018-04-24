#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Source RFFE mapping IPs
. ${SCRIPTPATH}/bpm-rffe-mapping.sh

IP="$1"
HOSTANAME_SUFFIX="$2"
CRATE_NUMBER_="$3"
# Remove leading zeros
CRATE_NUMBER="$(echo ${CRATE_NUMBER_} | sed 's/^0*//')"
SSHPASS_USR="$4"

HOSTANAME_PREFIX="cpu-bpm"
HOSTANAME="${HOSTANAME_PREFIX}"-${HOSTANAME_SUFFIX}
CRATE="CRATE_${CRATE_NUMBER}"

BPM_HALCS_CFG_TEMPLATE_IN_FILE="${SCRIPTPATH}/halcs_cfg.in"
BPM_HALCS_CFG_TEMPLATE_OUT_FILE="${SCRIPTPATH}/halcs.cfg"

BPM_EPICS_CFG_FILE="/etc/sysconfig/bpm-epics-ioc"
BPM_HALCS_CFG_FILE="/usr/local/etc/halcs/halcs.cfg"
TIM_RX_EPICS_CFG_FILE="/etc/sysconfig/tim-rx-epics-ioc"

## Ask sudo password only once and
## keep updating sudo timestamp to
## avoid asking again
#sudo -v
#while true; do sudo -n true; sleep 60; kill -0 "$$" || \
#    exit; done 2>/dev/null &
#
## Install packages
#sudo apt-get update && \
#sudo apt-get install -y \
#    openssh-client \
#    sshpass

# Generate HALCS config from template
BPM_MAX_NUM_BOARDS=12
BPM_MAX_NUM_HALCS=2
cp ${BPM_HALCS_CFG_TEMPLATE_IN_FILE} ${BPM_HALCS_CFG_TEMPLATE_OUT_FILE}
for board in `seq 1 ${BPM_MAX_NUM_BOARDS}`; do
    for halcs in `seq 0 $((${BPM_MAX_NUM_HALCS}-1))`; do
        bpm_rffe_ip_idx="${board}${halcs}"
        bpm_rffe_ip="BPM_RFFE_IP_MAPPING[${bpm_rffe_ip_idx}]"
        sed -i -e "s#<RFFE_BOARD${board}_HALCS${halcs}_IP>#${!bpm_rffe_ip}#" \
            ${BPM_HALCS_CFG_TEMPLATE_OUT_FILE}
    done
done

# Login via SSH and setup configuration files
SSHPASS="${SSHPASS_USR}" sshpass -e \
    ssh -o StrictHostKeyChecking=no \
    root@${IP} \
    bash -c "\
        echo \"\" > /etc/hostname && \
        sysctl kernel.hostname=${HOSTANAME} && \
        sed -i -e \"\
            { \
                s|EPICS_PV_CRATE_PREFIX=.*\$|EPICS_PV_CRATE_PREFIX=${CRATE}|; \
            }\" ${BPM_EPICS_CFG_FILE} && \
        sed -i -e \"\
            { \
                s|EPICS_PV_CRATE_PREFIX=.*\$|EPICS_PV_CRATE_PREFIX=${CRATE}|; \
            }\" ${TIM_RX_EPICS_CFG_FILE} \
    "

SSHPASS="${SSHPASS_USR}" sshpass -e \
    scp \
    ${BPM_HALCS_CFG_TEMPLATE_OUT_FILE} \
    root@${IP}:${BPM_HALCS_CFG_FILE}
