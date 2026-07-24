#!/bin/bash
set -e  # Exit on any error
installpac(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        sudo pacman -S --noconfirm --needed "$1"
    fi
}

# Installation of minimum packages
list=(
    base
    base-devel
    git
    pacman-contrib
    man-db
    vim
    gcc-libs
)

for name in "${list[@]}" ; do
	installpac $name
done
