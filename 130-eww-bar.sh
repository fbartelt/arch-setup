#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

list=(
pamixer
gtk3
glibc
libdbusmenu-gtk3
python3
python-setuptools
rustup
)
# gtk3 -> glibc -- eww dependencies
# python stuff -- zscroll
# zscroll -- music widget in bar

echo "Installing eww bar dependencies"
for name in "${list[@]}" ; do
	installpac $name
done

##### ZSCROLL #####
echo "Installing ZSCROLL from github"
git clone https://github.com/noctuid/zscroll /tmp/zscroll
cd /tmp/zscroll
sudo cp zscroll /usr/local/bin/
sudo chmod +x /usr/local/bin/zscroll
cd -
rm -rf /tmp/zscroll

##### EWW #####
# Install rustup using yay
echo "Installing rustup ..."
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable

# Clone and build eww
echo "Cloning and building eww..."
git clone https://github.com/elkowar/eww /tmp/eww
cd /tmp/eww
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  echo "Building for Wayland..."
  cargo build --release --no-default-features --features=wayland
else
  echo "Building for X11..."
  cargo build --release --no-default-features --features x11
fi

# Install eww globally
echo "Installing eww globally..."
sudo cp target/release/eww /usr/local/bin/

# Clean up
echo "Cleaning up..."
cd ~
rm -rf /tmp/eww


