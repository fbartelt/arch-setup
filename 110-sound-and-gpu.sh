#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
}

list=(
pipewire
pipewire-alsa
pipewire-audio
pipewire-jack
pipewire-pulse
pipewire-x11-bell
easyeffects
playerctl
pavucontrol
nvidia
nvidia-settings
nvidia-utils
nvidia-container-toolkit
nvidia-prime
opencl-nvidia
)

for name in "${list[@]}" ; do
	installpac $name
done

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
  echo "Running nvidia-xconfig"
  nvidia-xconfig
fi

echo "Installed pipewire and Nvidia packages. GPU must be configured manually."


