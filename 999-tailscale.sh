#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

echo "Installing tailscale"
installpac "tailscale"

sudo systemctl enable --now tailscaled

sudo tailscale up

echo "Installing keychain for ssh key"
installpac "keychain"

echo "Reboot your system."
