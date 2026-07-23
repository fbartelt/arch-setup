#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

# Installation of minimum packages
list=(
base-devel
git
pacman-contrib
man-db
lemurs
lightdm
lightdm-gtk-greeter
i3-wm
feh
rofi
kitty
neovim
vim
zsh
less
bat
lsd
numlockx
yad
fastfetch
gtk-layer-shell
pango
gdk-pixbuf2
cairo
glib2
gcc-libs
)

for name in "${list[@]}" ; do
	installpac $name
done

##### YAY #####
#Clone the yay repository to /tmp
echo "Cloning yay repository to /tmp..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay

# Build and install yay
echo "Building and installing yay..."
makepkg -si --noconfirm

# Clean up
echo "Cleaning up..."
cd ~
rm -rf /tmp/yay
echo "Yay installed successfully!"

##### Lemurs #####
echo "Enabling lemurs"

if systemctl is-active --quiet display-manager; then
  #current_dm_name=$(systemctl status display-manager | grep "Loaded:" | awk '{print $3}' | xargs -- basename)
  #echo "Current display manager is ${current_dm_name}. Disabling it..."
  #sudo systemctl disable "$current_dm_name" --now
  sudo systemctl disable display-manager.service --now
else
  echo "No active display manager found."
fi

# Enable lemurs
echo "Enabling lemurs..."
sudo systemctl enable lemurs.service -f --now

# Verify the change
echo "Verifying the new display manager..."
systemctl status display-manager

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

##### OH-MY-ZSH #####
# Set ZSH_CUSTOM if not already set, using $ZSH if available, else fallback to ~/.oh-my-zsh
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Installing zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
echo "Installing spaceship theme"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

##### CHANGING DEFAULTS #####
echo "Changing default shell to ZSH"
chsh -s "$(which zsh)" $USER
