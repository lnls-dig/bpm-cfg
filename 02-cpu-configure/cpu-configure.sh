#!/usr/bin/env bash

set -euo pipefail

CRATE_NUM="$1"

if [ -z "$CRATE_NUM" ]; then
	echo "Usage: $0 CRATE_NUM"
fi

if [ "$EUID" -ne 0 ]; then
   echo "This script must be run as root!"
   exit 1
fi

if [ "$CRATE_NUM" -eq 21 ]; then
	CRATE_FQDN="ia-20rabpmtl-co-iocsrv.lnls-sirius.com.br"
elif [ "$CRATE_NUM" -gt 21 ]; then
	CRATE_FQDN="de-${CRATE_NUM}rabpm-co-iocsrv.abtlus.org.br"
else
	CRATE_FQDN="ia-${CRATE_NUM}rabpm-co-iocsrv.lnls-sirius.com.br"
fi

hostnamectl set-hostname "$CRATE_FQDN"
sysctl kernel.hostname="$CRATE_FQDN"
sysctl -w kernel.hostname="$CRATE_FQDN"

apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install build-essential vim tmux git rsync sshfs telnet screen picocom earlyoom procserv arch-install-scripts zabbix-agent2 tcpdump gdb strace wget lsb-release iptables iptables-persistent -y
apt-get autoremove -y

iptables -t nat -A PREROUTING -p udp ! -s 127.0.0.1/24 --dport 5064 -j DNAT --to 255.255.255.255:5064
iptables-save > /etc/iptables/rules.v4

usermod -a lnls-bpm -G dialout
useradd iocs -m --no-user-group --shell /usr/sbin/nologin --home-dir /opt/container-iocs

loginctl enable-linger lnls-bpm
loginctl enable-linger iocs

cd /tmp
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb && sudo WAZUH_MANAGER='wazuh.cnpem.br' WAZUH_AGENT_GROUP='LNLS' dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb

sed -i '/Server=127.0.0.1/c\Server=zabbix.lnls.br' /etc/zabbix/zabbix_agent2.conf
sed -i '/ServerActive=127.0.0.1/c\ServerActive=zabbix.lnls.br' /etc/zabbix/zabbix_agent2.conf

sed -i '/GRUB_CMDLINE_LINUX=""/c\GRUB_CMDLINE_LINUX="pci=noaer intel_iommu=on console=ttyS0,115200"' /etc/default/grub
update-grub

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
genfstab -U / > /etc/fstab

printf "\ndeb http://deb.debian.org/debian/ bookworm-backports main non-free-firmware contrib non-free\n" >> /etc/apt/sources.list
apt-get update
apt-get install podman podman-compose -t bookworm-backports -y

printf '#/bin/sh\n\nset -e\nsnap_root_path=/snapshots/rootfs/rootfs-$(date +%%F-%%H-%%M-%%S)\nsnap_home_path=/snapshots/home/home-$(date +%%F-%%H-%%M-%%S)\n\n[ ! -e "$snap_root_path" ] && btrfs subvolume snapshot -r / "$snap_root_path"\n[ ! -e "$snap_home_path" ] && btrfs subvolume snapshot -r /home "$snap_home_path"\n' > /usr/local/bin/snapshot
chmod +x /usr/local/bin/snapshot

printf "#/bin/sh\nlspci  -mm -v | grep -e PhySlot  | tr '\t' ' '\n" > /usr/local/bin/pcie-list-slots
chmod +x /usr/local/bin/pcie-list-slots

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
}\n' | cc -O2 -o /usr/local/bin/pcie-rescan -xc -
chmod u+s /usr/local/bin/pcie-rescan

mkdir -p /opt/afc-epics-ioc/service
printf '#/bin/sh\necho IOC not installed yet!\n' > /opt/afc-epics-ioc/service/ioc-start.sh
chmod +x /opt/afc-epics-ioc/service/ioc-start.sh

printf "SUBSYSTEM==\"pci\", ATTR{vendor}==\"0x10ee\", ATTR{subsystem_device}==\"0x0007\", RUN+=\"/usr/bin/setpci -s %%k COMMAND=0x2\", RUN+=\"/bin/sh -c 'chmod 666 /sys/bus/pci/devices/%%k/resource*'\", RUN+=\"/opt/afc-epics-ioc/service/ioc-start.sh %%k\"" > /etc/udev/rules.d/95-afc.rules
