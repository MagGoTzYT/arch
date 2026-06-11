#!/bin/bash

set -e

echo "Arch Linux UEFI Base Install"
echo

lsblk
echo

read -rp "Disk to install to, for example /dev/nvme0n1 or /dev/sda: " DISK

if [ -z "$DISK" ] || [ ! -b "$DISK" ]; then
    echo "Invalid disk."
    exit 1
fi

echo
echo "WARNING: this will wipe $DISK"
read -rp "Type ERASE to continue: " CONFIRM

if [ "$CONFIRM" != "ERASE" ]; then
    echo "Cancelled."
    exit 1
fi

if [[ "$DISK" == *"nvme"* || "$DISK" == *"mmcblk"* ]]; then
    EFI="${DISK}p1"
    BOOT="${DISK}p2"
    ROOT="${DISK}p3"
else
    EFI="${DISK}1"
    BOOT="${DISK}2"
    ROOT="${DISK}3"
fi

timedatectl set-ntp true

swapoff -a || true
umount -R /mnt 2>/dev/null || true

wipefs -af "$DISK"

parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart ESP fat32 1MiB 513MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary ext4 513MiB 1537MiB
parted -s "$DISK" mkpart primary btrfs 1537MiB 100%

mkfs.fat -F32 "$EFI"
mkfs.ext4 -F "$BOOT"
mkfs.btrfs -f "$ROOT"

mount "$ROOT" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

umount /mnt

mount -o noatime,compress=zstd,ssd,discard=async,subvol=@ "$ROOT" /mnt

mkdir -p /mnt/boot /mnt/home
mount -o noatime,compress=zstd,ssd,discard=async,subvol=@home "$ROOT" /mnt/home

mount "$BOOT" /mnt/boot
mkdir -p /mnt/boot/efi
mount "$EFI" /mnt/boot/efi

pacstrap -K /mnt \
    base \
    linux \
    linux-firmware \
    sudo \
    vim \
    nano \
    git \
    networkmanager \
    grub \
    efibootmgr \
    btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab

mkdir -p /mnt/root/install-files
cp -r . /mnt/root/install-files

echo
echo "Base install complete."
echo
echo "Next:"
echo "arch-chroot /mnt"
echo "cd /root/install-files"
echo "./archinstall.sh"
