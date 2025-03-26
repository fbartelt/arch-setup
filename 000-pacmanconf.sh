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

sudo pacman -S wget --noconfirm --needed
sudo pacman -S jq --noconfirm --needed
arco_repo_db=$(wget -qO- https://api.github.com/repos/arcolinux/arcolinux_repo/contents/x86_64)
echo "Getting the ArcoLinux keys from the ArcoLinux repo"

sudo wget "$(echo "$arco_repo_db" | jq -r '[.[] | select(.name | contains("arcolinux-keyring")) | .name] | .[0] | sub("arcolinux-keyring-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-")')" -O /tmp/arcolinux-keyring-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-git-any.pkg.tar.zst

echo "Getting the latest arcolinux mirrors file"

sudo wget "$(echo "$arco_repo_db" | jq -r '[.[] | select(.name | contains("arcolinux-mirrorlist-git-")) | .name] | .[0] | sub("arcolinux-mirrorlist-git-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-")')" -O /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst
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
        # Copy keyring
        curl -O https://mirrors.tuna.tsinghua.edu.cn/arch4edu/any/arch4edu-keyring-20200805-1-any.pkg.tar.zst
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
