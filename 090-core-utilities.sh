#!/bin/bash
set -e  # Exit on any error
installpac(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        sudo pacman -S --noconfirm --needed "$1"
    fi
}


list=(
networkmanager
network-manager-applet
vlc
vlc-plugin-ffmpeg
zip
unzip
unrar
7zip
btop
ncdu
neovim
arandr
lxappearance
gnome-keyring
fzf
fd
thunar
thunar-volman
gvfs
ranger
speedtest-cli
xclip
pass
lazygit
less
bat
lsd
ripgrep
feh
rofi
kitty
fastfetch
)
# gvfs for thunar removable media / trash etc.

echo "Installing utility softwares"

for name in "${list[@]}" ; do
	installpac $name
done

echo "Enabling NetworkManager.service"
sudo systemctl enable --now NetworkManager.service 

