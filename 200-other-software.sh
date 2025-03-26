#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
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
htop
ncdu
spotify
blender
vokoscreen
i3lock-color
xournalpp
ranger
libreoffice-fresh
okular
visual-studio-code-bin
mendeleydesktop-bundled
arandr
lxappearance
)

for name in "${list[@]}" ; do
	installpac $name
done


