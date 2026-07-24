#!/bin/bash
set -e  # Exit on any error
installpac(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        sudo pacman -S --noconfirm --needed "$1"
    fi
}

# Installation of lemurs and fallback dm
list=(
lemurs
lightdm
lightdm-gtk-greeter
)

for name in "${list[@]}" ; do
	installpac $name
done

# Create the /etc/lemurs/wms directory if it doesn't exist
echo "Creating /etc/lemurs/wms directory..."
sudo mkdir -p /etc/lemurs/wms

# Create the i3 configuration file
echo "Creating /etc/lemurs/wms/i3..."
sudo tee /etc/lemurs/wms/i3 > /dev/null << 'EOF'
#! /bin/sh
exec i3
EOF

# Make the file executable
echo "Making /etc/lemurs/wms/i3 executable..."
sudo chmod +x /etc/lemurs/wms/i3

echo "i3 configuration for lemurs created successfully!"

echo "Enabling lemurs"
if systemctl is-active --quiet display-manager; then
  #current_dm_name=$(systemctl status display-manager | grep "Loaded:" | awk '{print $3}' | xargs -- basename)
  #echo "Current display manager is ${current_dm_name}. Disabling it..."
  #sudo systemctl disable "$current_dm_name" --now
    sudo systemctl disable display-manager.service --now 2>/dev/null || true
else
  echo "No active display manager found."
fi

# Enable lemurs
echo "Enabling lemurs..."
sudo systemctl enable lemurs.service -f --now

# Verify the change
echo "Verifying the new display manager..."
systemctl status display-manager


