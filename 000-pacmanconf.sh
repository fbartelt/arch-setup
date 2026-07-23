#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

installpac reflector

echo "Updating mirrorlist with reflector..."
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

# Backup the existing pacman.conf
sudo cp /etc/pacman.conf /etc/pacman.conf.bak

# Update pacman.conf with custom options
echo "Updating pacman.conf with custom options..."
options=(
  "DisableDownloadTimeout"
  "ILoveCandy"
  "ParallelDownloads = 5"
  "VerbosePkgLists"
  "CheckSpace"
  "Color"
)
# Comment out all existing Misc options
sudo sed -i '/^# Misc options$/,/^$/s/^\([^#]\)/#\1/' /etc/pacman.conf
# Add the new Misc options
if grep -q "^# Misc options$" /etc/pacman.conf; then
  for option in "${options[@]}"; do
    sudo sed -i "/^# Misc options$/a ${option}" /etc/pacman.conf
  done
else
  echo -e "\n# Misc options" | sudo tee -a /etc/pacman.conf > /dev/null
  for option in "${options[@]}"; do
    echo "${option}" | sudo tee -a /etc/pacman.conf > /dev/null
  done
fi

# Check if a repository is already in pacman.conf
repo_exists() {
    grep -q "^\[$1\]" /etc/pacman.conf
}

# Add arch4edu repository (if not already present)
echo "Adding arch4edu repository..."
if ! repo_exists "arch4edu"; then
        # Copy keyring
        #curl -O https://mirrors.tuna.tsinghua.edu.cn/arch4edu/any/arch4edu-keyring-20200805-1-any.pkg.tar.zst
        # Verify the SHA256 checksum
        echo "Verifying SHA256 checksum..."
        #expected_checksum="a6abbb16e57bb9065689f5b5391c945e35e256f2e6dbfa11476fdfe880f72775"
        #actual_checksum=$(sha256sum arch4edu-keyring-20200805-1-any.pkg.tar.zst | awk '{print $1}')

        #if [ "$expected_checksum" = "$actual_checksum" ]; then
        #    echo "Checksum verified. Installing arch4edu keyring..."
        #    sudo pacman -U --noconfirm arch4edu-keyring-20200805-1-any.pkg.tar.zst
        #else
        #    echo "Checksum verification failed. Skipping arch4edu installation."
        #fi
	pacman-key --recv-keys 7931B6D628C8D3BA
	pacman-key --finger 7931B6D628C8D3BA
	pacman-key --lsign-key 7931B6D628C8D3BA
     sudo cat <<EOF | sudo tee -a /etc/pacman.conf
[arch4edu]
Server = https://repository.arch4edu.org/\$arch
EOF

echo "Cleaning up..."
rm -f arch4edu-keyring-20200805-1-any.pkg.tar.zst
else
    echo "Repository [arch4edu] already exists. Skipping..."
fi
# Update the package database
echo "Updating package database..."
sudo pacman -Syy

echo "Repositories added successfully!"
