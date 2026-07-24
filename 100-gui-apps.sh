#!/bin/bash
set -e  # Exit on any error
installpac(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        sudo pacman -S --noconfirm --needed "$1"
    fi
}
installyay(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        yay -S --noconfirm --needed "$1"
    fi
}
list=(
firefox
flameshot
redshift
inkscape
gimp
telegram-desktop
kdenlive
spotify-launcher
vokoscreen
xournalpp
libreoffice-fresh
okular
mendeleydesktop-bundled
qbittorrent
task
)
# mendeley is in arch4edu

list_yay=(
mons
i3lock-color
weylus
)

for name in "${list[@]}" ; do
	installpac $name
done

for name in "${list_yay[@]}" ; do
    installyay $name
done
