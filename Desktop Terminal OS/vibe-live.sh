#!/bin/bash
# build-debian-iso-persistent-file.sh
# Creates a bootable Debian live ISO with built-in persistence

set -e

# ========================
# Configuration
# ========================
DEBIAN_RELEASE="bookworm"
ARCH="amd64"
TARGET_DIR="./debian-root"
ISO_DIR="./iso"
ISO_NAME="mydebian-persistent.iso"
MIRROR="http://deb.debian.org/debian"
HOSTNAME="mydebian"
USERNAME="user"
PERSISTENCE_SIZE="2G"   # size of persistence file

# ========================
# Install required packages
# ========================
sudo apt update
sudo apt install -y debootstrap squashfs-tools xorriso \
    grub-pc-bin grub-efi-amd64-bin mtools

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
sudo mkdir -p "$ISO_DIR/boot/grub/live"

# Copy kernel and initramfs
KERNEL=$(ls "$TARGET_DIR/boot/vmlinuz-"* | sort | tail -n1)
INITRD=$(ls "$TARGET_DIR/boot/initrd.img-"* | sort | tail -n1)
sudo cp "$KERNEL" "$ISO_DIR/boot/vmlinuz"
sudo cp "$INITRD" "$ISO_DIR/boot/initrd"

# ========================
# Step 5: Create squashfs of rootfs
# ========================
sudo mksquashfs "$TARGET_DIR" "$ISO_DIR/live/filesystem.squashfs" -e boot

# ========================
# Step 6: Create persistence file
# ========================
sudo dd if=/dev/zero of="$ISO_DIR/live/persistence.dat" bs=1M count=0 seek=$(( $(echo $PERSISTENCE_SIZE | sed 's/G/*1024/') ))
sudo mkfs.ext4 -F "$ISO_DIR/live/persistence.dat"
# Label it for live-boot recognition
sudo e2label "$ISO_DIR/live/persistence.dat" persistence

# ========================
# Step 7: Create persistence configuration
# ========================
cat << EOF | sudo tee "$ISO_DIR/live/persistence.conf"
# Persist home and etc
/home
/etc
/var
EOF

# ========================
# Step 8: Create GRUB configuration
# ========================
cat << EOF | sudo tee "$ISO_DIR/boot/grub/grub.cfg"
set default=0
set timeout=5

menuentry "My Debian Minimal (Persistent)" {
    linux /boot/vmlinuz boot=live persistence persistence-file=/live/persistence.dat quiet
    initrd /boot/initrd
}
EOF

# ========================
# Step 9: Create bootable ISO
# ========================
sudo grub-mkrescue -o "$ISO_NAME" "$ISO_DIR"

echo "✅ Bootable persistent ISO created: $ISO_NAME"
echo "Changes to /home, /etc, /var will persist using the embedded persistence.dat file."
