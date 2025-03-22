#!/bin/bash

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
# Add standard Arch Linux repositories (if not already present)
echo "Adding standard Arch Linux repositories..."
for repo in core extra community multilib; do
    if ! repo_exists "$repo"; then
        sudo cat <<EOF | sudo tee -a /etc/pacman.conf
[$repo]
Include = /etc/pacman.d/mirrorlist
EOF
    else
        echo "Repository [$repo] already exists. Skipping..."
    fi
done

# Download and save the arcolinux-mirrorlist
echo "Downloading arcolinux-mirrorlist..."
sudo curl -o /etc/pacman.d/arcolinux-mirrorlist https://raw.githubusercontent.com/arcolinux/arcolinux-mirrorlist/master/etc/pacman.d/arcolinux-mirrorlist

# Add Arcolinux repositories (if not already present)
echo "Adding Arcolinux repositories..."
for repo in arcolinux_repo arcolinux_repo_3party arcolinux_repo_xlarge; do
    if ! repo_exists "$repo"; then
       sudo cat <<EOF | sudo tee -a /etc/pacman.conf
[$repo]
SigLevel = Optional TrustedOnly
Include = /etc/pacman.d/arcolinux-mirrorlist
EOF
    else
        echo "Repository [$repo] already exists. Skipping..."
    fi
done

# Add arch4edu repository (if not already present)
echo "Adding arch4edu repository..."
if ! repo_exists "arch4edu"; then
    # Verify the SHA256 checksum
        echo "Verifying SHA256 checksum..."
        expected_checksum="a6abbb16e57bb9065689f5b5391c945e35e256f2e6dbfa11476fdfe880f72775"
        actual_checksum=$(sha256sum arch4edu-keyring-20200805-1-any.pkg.tar.zst | awk '{print $1}')

        if [ "$expected_checksum" = "$actual_checksum" ]; then
            echo "Checksum verified. Installing arch4edu keyring..."
            sudo pacman -U --noconfirm arch4edu-keyring-20200805-1-any.pkg.tar.zst
        else
            echo "Checksum verification failed. Skipping arch4edu installation."
        fi
     sudo cat <<EOF | sudo tee -a /etc/pacman.conf
[arch4edu]
Server = https://mirror.archlinuxcn.org/\$arch
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
