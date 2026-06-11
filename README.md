# archinstall

A small set of Arch Linux install scripts.

This is not meant to be a huge automated installer. It is just a simple helper repo for installing a basic UEFI Arch system, then optionally adding KDE, GNOME, or Hyprland.

## Files

```text
baseuefi.sh      # partition, format, mount, and pacstrap the base system
archinstall.sh   # basic system setup inside arch-chroot
desktop.sh       # optional desktop install
.config/         # dotfiles/configs
```

## Before using

Boot into the Arch ISO and connect to the internet.

Check your disks first:

```bash
lsblk
```

## Usage

```bash
pacman -Sy git
git clone https://github.com/MagGoTzYT/archinstall
cd archinstall
chmod +x *.sh
./baseuefi.sh
```

When `baseuefi.sh` finishes:

```bash
arch-chroot /mnt
cd /root/install-files
./archinstall.sh
```

After rebooting into the system, you can install a desktop with:

```bash
./desktop.sh
```

## Notes

The script asks you for your disk, hostname, and username.

Nothing is hardcoded to my setup.

## Warning

`baseuefi.sh` can wipe a disk. Read the prompts carefully.
