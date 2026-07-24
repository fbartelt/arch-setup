#!/bin/bash
set -e  # Exit on any error
#Clone the yay repository to /tmp
echo "Cloning yay repository to /tmp..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay

# Build and install yay
echo "Building and installing yay..."
makepkg -si --noconfirm

# Clean up
echo "Cleaning up..."
cd -
rm -rf /tmp/yay
echo "Yay installed successfully!"
