#!/bin/bash
set -e  # Exit on any error
installpac(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        sudo pacman -S --noconfirm --needed "$1"
    fi
}

# Installation of zsh, oh-my-zsh and plugins
list=(
zsh
)

for name in "${list[@]}" ; do
	installpac $name
done

##### OH-MY-ZSH #####
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Installing zsh-syntax-highlighting"
# Set ZSH_CUSTOM if not already set, using $ZSH if available, else fallback to ~/.oh-my-zsh
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
echo "Installing spaceship theme"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

##### CHANGING DEFAULTS #####
echo "Changing default shell to ZSH"
chsh -s "$(which zsh)" $USER
