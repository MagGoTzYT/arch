#!/bin/bash

echo "This install script will install the following packages: Gaming, Desktop, and other software that I use."
read -p "Would you like to continue? (y/n) " choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Now installing My Gaming Packages"
else
    echo "Exiting"
    exit 1
fi

## installing yay 
sudo pacman -Syu
sudo pacman -S needed-base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


## installing my main gaming packages
sudo pacman -S steam
sudo pacman -S wine-staging
sudo pacman -S wine-mono
sudo pacman -S wine-gecko
sudo pacman -S wine-tools
yay -S heroic-games-launcher-bin

read -p "Would you like to download my desktop applications? (y/n) " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Now installing My Desktop Packages"
else
    echo "Exiting..."
    exit 0
fi

yay -S google-chrome
yay -S obs-studio
yay -S discord
yay -S spotify
yay -S nitch