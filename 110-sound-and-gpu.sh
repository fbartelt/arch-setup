#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
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
nvidia-open
nvidia-settings
nvidia-utils
nvidia-container-toolkit
nvidia-prime
opencl-nvidia
pamixer
)

for name in "${list[@]}" ; do
	installpac $name
done


echo "Configuring NVIDIA graphics only"
# https://wiki.archlinux.org/title/NVIDIA_Optimus#Use_NVIDIA_graphics_only
sudo cat > /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf << EOF
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
EOF

echo "Installed pipewire and Nvidia packages."
echo "Add these to .xinitrc or i3/config:xrandr --setprovideroutputsource modesetting NVIDIA-0\nxrandr --auto"


