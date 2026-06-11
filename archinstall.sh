#!/bin/bash

set -e

echo "Arch Linux System Setup"
echo

read -rp "Hostname: " HOSTNAME
read -rp "Username: " USERNAME

if [ -z "$HOSTNAME" ]; then
    echo "Hostname cannot be empty."
    exit 1
fi

if [ -z "$USERNAME" ]; then
    echo "Username cannot be empty."
    exit 1
fi

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf
echo "$HOSTNAME" > /etc/hostname

cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 $HOSTNAME.localdomain $HOSTNAME
EOF

echo
echo "Set root password:"
passwd

useradd -m -G wheel -s /bin/bash "$USERNAME"

echo
echo "Set password for $USERNAME:"
passwd "$USERNAME"

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

if grep -q "GenuineIntel" /proc/cpuinfo; then
    pacman -S --needed --noconfirm intel-ucode
elif grep -q "AuthenticAMD" /proc/cpuinfo; then
    pacman -S --needed --noconfirm amd-ucode
fi

systemctl enable NetworkManager

mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

echo
read -rp "Install a desktop now? [y/N]: " DESKTOP_NOW

if [[ "$DESKTOP_NOW" =~ ^[Yy]$ ]]; then
    ./desktop.sh
fi

echo
echo "Install complete."
echo
echo "Next:"
echo "exit"
echo "umount -R /mnt"
echo "reboot"
