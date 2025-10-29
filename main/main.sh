#!/bin/bash

# Pre-checks
apt update

# GUI
apt install ubuntu-gnome-desktop

# Create the partitions
# manual

# Make the directories
mkdir ~/os ~/os/this ~/os/zammad ~/os/bw ~/os/element ~/os/img
mkdir ~/vm ~/vm/zammad ~/vm/bw ~/vm/element ~/vm/desktop ~/vm/graphics ~/vm/company
mkdir ~/graphics
mkdir ~/company
mkdir ~/backup ~/backup/graphics ~/backup/company ~/backup/qb ~/backup/vm

# Mount the partitions
# manual

# Create disk images
qemu-img create -f qcow2 ~/vm/zammad/zammad-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/zammad/zammad-data.qcow2 10G

qemu-img create -f qcow2 ~/vm/bw/bw-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/bw/bw-data.qcow2 10G

qemu-img create -f qcow2 ~/vm/element/element-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/element/element-data.qcow2 10G

qemu-img create -f qcow2 ~/vm/desktop/desktop-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/desktop/desktop-data.qcow2 10G

qemu-img create -f qcow2 ~/vm/graphics/graphics-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/graphics/graphics-data.qcow2 10G

qemu-img create -f qcow2 ~/vm/company/company-os.qcow2 10G
qemu-img create -f qcow2 ~/vm/company/company-data.qcow2 10G

# Install KVM
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager qemu-utils
sudo systemctl enable --now libvirtd



