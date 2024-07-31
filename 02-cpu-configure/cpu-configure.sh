#!/usr/bin/env bash
#
# MicroTCA CPU configuration script. Expects a fresh Debian 12 install
# on a BTRFS filesystem.

set -euo pipefail

CRATE_NUM="$1"

if [ -z "$CRATE_NUM" ]; then
    echo "Usage: $0 CRATE_NUM"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 2
fi

if [ "$CRATE_NUM" -eq 21 ]; then
    CRATE_HOSTNAME="ia-20rabpmtl-co-iocsrv"
elif [ "$CRATE_NUM" -gt 21 ]; then
    CRATE_HOSTNAME="de-${CRATE_NUM}rabpm-co-iocsrv"
else
    CRATE_HOSTNAME="ia-${CRATE_NUM}rabpm-co-iocsrv"
fi

sysctl -w kernel.hostname="$CRATE_HOSTNAME"
hostnamectl hostname "$CRATE_HOSTNAME"

# Disable prompts during packages installation.
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get dist-upgrade -y
apt-get install build-essential vim tmux git rsync sshfs telnet screen picocom earlyoom procserv arch-install-scripts zabbix-agent2 tcpdump gdb strace wget lsb-release iptables iptables-persistent systemd-timesyncd -y
apt-get autoremove -y

# Replicate UDP packets to all listeners (EPICS IOCs).
iptables -t nat -A PREROUTING -p udp ! -s 127.0.0.1/24 --dport 5064 -j DNAT --to 255.255.255.255:5064
iptables-save > /etc/iptables/rules.v4

usermod -a lnls-bpm -G dialout
usermod -a lnls-bpm -G systemd-journal
useradd iocs -m --no-user-group --shell /usr/sbin/nologin --home-dir /opt/container-iocs

loginctl enable-linger lnls-bpm
loginctl enable-linger iocs

cd /tmp
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb && sudo WAZUH_MANAGER='wazuh.cnpem.br' WAZUH_AGENT_GROUP='LNLS' dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb

sed -i '/Server=127.0.0.1/c\Server=zabbix.lnls.br' /etc/zabbix/zabbix_agent2.conf
sed -i '/ServerActive=127.0.0.1/c\ServerActive=zabbix.lnls.br' /etc/zabbix/zabbix_agent2.conf

# Disable PCIe Advanced Error Recovery (to make PCIe hotswap work
# properly), enable Intel IOMMU, configure a console session for the
# ttyS1 serial port.
sed -i '/GRUB_CMDLINE_LINUX=""/c\GRUB_CMDLINE_LINUX="pci=noaer intel_iommu=on console=ttyS1,115200"' /etc/default/grub
update-grub

# Create different subvolumes for /home and /snapshots mount
# points. This assumes that the current root partition is already a
# BTRFS subvolume (the Debian installer automatically creates the
# @rootfs subvolume if you choose the BTRFS filesystem for your root
# volume).
ROOTFS_PART=`findmnt -n -r / | cut -d ' '  -f 2 | cut -d '[' -f 1`
mount $ROOTFS_PART /mnt/
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@home
mv /home/lnls-bpm /mnt/@home
mkdir /mnt/@snapshots/rootfs
mkdir /mnt/@snapshots/home
umount /mnt
mkdir /snapshots
mount $ROOTFS_PART /home -o subvol=/@home
mount $ROOTFS_PART /snapshots -o subvol=/@snapshots

# Generate a new fstab to account for the mount points configured
# previously.
genfstab -U / > /etc/fstab

# BTRFS snapshot creation utility. It will create a new snapshot of /
# and /home and save them in /snapshots when invoked.
printf '#/bin/sh

set -e
snap_root_path=/snapshots/rootfs/rootfs-$(date +%%F-%%H-%%M-%%S)
snap_home_path=/snapshots/home/home-$(date +%%F-%%H-%%M-%%S)

[ ! -e "$snap_root_path" ] && btrfs subvolume snapshot -r / "$snap_root_path"
[ ! -e "$snap_home_path" ] && btrfs subvolume snapshot -r /home "$snap_home_path"
' > /usr/local/bin/snapshot
chmod +x /usr/local/bin/snapshot

# Script to list active PCIe physical slots (AMC cards).
printf "#/bin/sh
lspci  -mm -v | grep -e PhySlot  | tr '\\\t' ' ' | sort -t' ' -nk2
" > /usr/local/bin/pcie-list-slots
chmod +x /usr/local/bin/pcie-list-slots

# Utility to rescan the PCIe buses to check if there are new
# devices. Very useful to recover from 'Powering on due to button
# press' situations. It has to be a binary executable otherwise the
# Linux kernel will ignore the suid bit.
printf '#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char** argv) {
  int fd = open("/sys/bus/pci/rescan", O_WRONLY);
  if (fd < 0) {
    fprintf(stderr, "Could not write to /sys/bus/pci/rescan. Are you running it as root?\\n");
    return 1;
  }
  write(fd, "1\\n", 2);
  close(fd);
  return 0;
}
' | cc -O2 -o /usr/local/bin/pcie-rescan -xc -
chmod u+s /usr/local/bin/pcie-rescan
