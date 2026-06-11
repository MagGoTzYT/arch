#!/bin/bash

set -e

echo "Desktop Install"
echo
echo "1) KDE Plasma"
echo "2) GNOME"
echo "3) Hyprland"
echo "4) Cancel"
echo

read -rp "Choose a desktop: " CHOICE

case "$CHOICE" in
    1)
        pacman -S --needed --noconfirm \
            plasma \
            sddm \
            konsole \
            dolphin \
            firefox

        systemctl enable sddm
        ;;

    2)
        pacman -S --needed --noconfirm \
            gnome \
            gdm \
            firefox

        systemctl enable gdm
        ;;

    3)
        pacman -S --needed --noconfirm \
            hyprland \
            waybar \
            wofi \
            kitty \
            dolphin \
            firefox \
            sddm \
            xdg-desktop-portal-hyprland

        systemctl enable sddm
        ;;

    4)
        echo "Cancelled."
        exit 0
        ;;

    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo
echo "Desktop install complete."
