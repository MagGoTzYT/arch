#!/usr/bin/env bash
set -euo pipefail

### Simple KDE Plasma install script for Arch Linux
### Run: sudo bash install-kde.sh

# ----- Safety checks -----
if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run this script as root (e.g. with: sudo bash install-kde.sh)"
  exit 1
fi

if ! grep -qi "arch" /etc/os-release 2>/dev/null; then
  echo "This script is intended for Arch Linux only."
  exit 1
fi

echo "This will install KDE Plasma desktop and related packages on Arch Linux."
read -rp "Continue? (y/N): " choice
case "$choice" in
  y|Y) echo "Continuing..." ;;
  *)   echo "Aborting."; exit 0 ;;
esac

# ----- Full system upgrade -----
echo "Updating system (pacman -Syu)..."
pacman -Syu --noconfirm

# ----- Core graphics / desktop packages -----
echo "Installing KDE Plasma and dependencies..."

# If you are using Wayland, plasma-meta is good.
# For X11, this also works; you can log into X11 or Wayland from SDDM.
pacman -S --noconfirm --needed \
  plasma-meta \
  kde-applications-meta \
  sddm \
  konsole \
  dolphin \
  kate \
  ark \
  spectacle \
  firefox \
  networkmanager \
  network-manager-applet

# ----- Enable NetworkManager (if not already) -----
echo "Enabling NetworkManager..."
systemctl enable NetworkManager.service

# ----- Enable SDDM display manager -----
echo "Enabling SDDM display manager..."
systemctl enable sddm.service

# ----- Optional: PipeWire (audio) -----
echo "Installing and enabling PipeWire audio stack..."
pacman -S --noconfirm --needed \
  pipewire \
  pipewire-alsa \
  pipewire-pulse \
  pipewire-jack \
  wireplumber

systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service || true

echo
echo "KDE Plasma install complete!"
echo "- Reboot your system: sudo reboot"
echo "- SDDM will start and allow you to log into KDE Plasma."
