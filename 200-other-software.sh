#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

installyay(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        yay -S --noconfirm --needed $1
    fi
}

list=(
networkmanager
network-manager-applet
firefox
flameshot
redshift
inkscape
gimp
vlc
zip
unzip
unrar
telegram-desktop
btop
ncdu
spotify-launcher
blender
vokoscreen
xournalpp
libreoffice-fresh
okular
neovim
mendeleydesktop-bundled
arandr
lxappearance
gnome-keyring
qbittorrent
fzf
fd
thunar
thunar-volman
ranger
speedtest-cli
task
xclip
pass
lazygit
)

list_yay=(
mons
i3lock-color
)

for name in "${list[@]}" ; do
	installpac $name
done

for name in "${list_yay[@]}" ; do
    installyay $name
done
