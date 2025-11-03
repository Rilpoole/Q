#!/bin/bash
# build-debian-iso.sh
# Creates a fully bootable minimal Debian ISO

set -e

# ========================
# Configuration
# ========================
DEBIAN_RELEASE="bookworm"      # Debian release
ARCH="amd64"
TARGET_DIR="./debian-root"     # Root filesystem
ISO_DIR="./iso"                # ISO staging directory
ISO_NAME="mydebian.iso"
MIRROR="http://deb.debian.org/debian"
HOSTNAME="mydebian"
USERNAME="user"

# ========================
# Install required packages
# ========================
sudo apt update
sudo apt install -y debootstrap squashfs-tools xorriso \
    grub-pc-bin grub-efi-amd64-bin mtools isolinux syslinux-utils

# ========================
# Step 1: Bootstrap minimal Debian
# ========================
sudo rm -rf "$TARGET_DIR"
sudo debootstrap --arch="$ARCH" "$DEBIAN_RELEASE" "$TARGET_DIR" "$MIRROR"

# ========================
# Step 2: Configure minimal system
# ========================
sudo chroot "$TARGET_DIR" /bin/bash -c "
echo '$HOSTNAME' > /etc/hostname
echo '127.0.0.1 localhost' > /etc/hosts

apt update
apt install -y sudo vim bash-completion net-tools ifupdown iproute2 \
    systemd-sysv linux-image-amd64

# Create user
useradd -m -s /bin/bash $USERNAME
echo '$USERNAME:password' | chpasswd
usermod -aG sudo $USERNAME
"

# ========================
# Step 3: Setup fstab
# ========================
cat << EOF | sudo tee "$TARGET_DIR/etc/fstab"
proc    /proc   proc    defaults 0 0
sysfs   /sys    sysfs   defaults 0 0
devpts  /dev/pts devpts  defaults 0 0
tmpfs   /tmp    tmpfs   defaults 0 0
EOF

# ========================
# Step 4: Prepare ISO directory
# ========================
sudo rm -rf "$ISO_DIR"
sudo mkdir -p "$ISO_DIR/boot/grub"

# Copy kernel and initramfs
KERNEL=$(ls "$TARGET_DIR/boot/vmlinuz-"* | sort | tail -n1)
INITRD=$(ls "$TARGET_DIR/boot/initrd.img-"* | sort | tail -n1)
sudo cp "$KERNEL" "$ISO_DIR/boot/vmlinuz"
sudo cp "$INITRD" "$ISO_DIR/boot/initrd"

# ========================
# Step 5: Create GRUB configuration
# ========================
cat << EOF | sudo tee "$ISO_DIR/boot/grub/grub.cfg"
set default=0
set timeout=5

menuentry "My Debian Minimal" {
    linux /boot/vmlinuz root=/dev/ram0 rw
    initrd /boot/initrd
}
EOF

# ========================
# Step 6: Create squashfs of rootfs
# ========================
sudo mksquashfs "$TARGET_DIR" "$ISO_DIR/filesystem.squashfs" -e boot

# ========================
# Step 7: Create bootable ISO
# ========================
sudo grub-mkrescue -o "$ISO_NAME" "$ISO_DIR"

echo "✅ Bootable ISO created: $ISO_NAME"
echo "You can now test it in VirtualBox or QEMU."
