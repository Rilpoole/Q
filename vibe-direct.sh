Skip to content
You said:
let's build a script to make a minimal bootable debian
ChatGPT said:

Perfect! Creating a minimal bootable Debian system can be done in several ways, depending on your target environment (VM, physical hardware, or container). Since you said "script," I’ll guide you toward an automated setup using debootstrap, which is the standard tool to create minimal Debian systems.

Here’s a step-by-step approach, and then I’ll give you a ready-to-run script.
1. Prerequisites

On your host system, you need:

    debootstrap

    qemu or chroot access if testing in a VM

    grub (for bootloader, if making it bootable on real hardware)

Install prerequisites on a Debian host:

sudo apt update
sudo apt install debootstrap grub-pc-bin grub-efi-amd64-bin syslinux-utils xorriso

2. Decide the target

    TARGET_DIR → where the minimal system will live

    ARCH → e.g., amd64

    RELEASE → e.g., bookworm or trixie

3. Minimal bootstrap with debootstrap

debootstrap can install a minimal Debian base into a directory:

sudo debootstrap --arch=amd64 bookworm /mnt/debian-minimal http://deb.debian.org/debian/

This gives you a chroot-ready minimal system.
4. Configure minimal system

Inside /mnt/debian-minimal:

sudo chroot /mnt/debian-minimal /bin/bash

# Set hostname
echo "minimal-debian" > /etc/hostname

# Configure /etc/hosts
cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   minimal-debian
EOF

# Set root password
passwd

# Minimal fstab (adjust /dev/sdX1 to your device)
cat <<EOF > /etc/fstab
/dev/sda1 / ext4 defaults 0 1
EOF

# Install basic packages
apt update
apt install --no-install-recommends systemd-sysv sudo ssh

5. Install bootloader

For BIOS (grub-pc):

grub-install --root-directory=/mnt/debian-minimal /dev/sda
chroot /mnt/debian-minimal update-grub

For UEFI (grub-efi-amd64):

apt install grub-efi-amd64
mkdir -p /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian --recheck
update-grub

6. Exit and test

Unmount everything and boot your system in VM or hardware.
7. Automating with a script

Here’s a ready-to-run Bash script for a minimal bootable Debian (BIOS):

#!/bin/bash
set -e

TARGET_DIR="$1"
RELEASE="bookworm"
ARCH="amd64"
MIRROR="http://deb.debian.org/debian"

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 /path/to/target"
    exit 1
fi

# 1. Bootstrap Debian
sudo debootstrap --arch=$ARCH $RELEASE "$TARGET_DIR" $MIRROR

# 2. Configure minimal system
sudo chroot "$TARGET_DIR" /bin/bash -c "
echo 'minimal-debian' > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   minimal-debian
EOF
apt update
apt install --no-install-recommends -y systemd-sysv sudo ssh grub-pc
passwd
"

# 3. Install GRUB (BIOS)
sudo grub-install --root-directory="$TARGET_DIR" /dev/sda
sudo chroot "$TARGET_DIR" update-grub

echo "Minimal Debian installed at $TARGET_DIR"

✅ This script gives you a bootable minimal Debian. From here, you can extend it with networking, SSH keys, or a minimal GUI if you want.

If you want, I can also write a version that produces a bootable ISO directly, so you can boot it in VirtualBox or QEMU without touching /dev/sda. That’s even more “scriptable” and clean.

Do you want me to do that?


ChatGPT can make mistakes. Check important info.
