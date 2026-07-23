#!/bin/bash
installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
    fi
}

installyay(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        yay -S --noconfirm --needed $1
    fi
}

list=(
sdl2_ttf
ttf-dejavu
ttf-fira-code
woff2-font-awesome
ttf-hack
ttf-liberation
ttf-nerd-fonts-symbols
)

for name in "${list[@]}" ; do
	installpac $name
done

echo "Installing AUR packages"

list_yay=(
ttf-material-icons-git
)

for name in "${list_yay[@]}" ; do
	installyay $name
done

echo "Installing MPlus fonts from github"
mkdir -p .local/share/fonts/ttf/MPlus
mkdir -p .local/share/fonts/otf/MPlus
mkdir -p .local/share/fonts/woff2/MPlus

git clone https://github.com/coz-m/MPLUS_FONTS.git /tmp/MPLUS_FONTS

# Copy all .ttf files from any ttf/ subdirectory
find /tmp/MPLUS_FONTS/fonts -type f -path '*/ttf/*.ttf' -exec cp {} .local/share/fonts/ttf/MPlus/ \;
find /tmp/MPLUS_FONTS/fonts -type f -path '*/variable/*.ttf' -exec cp {} .local/share/fonts/ttf/MPlus/ \;

# Copy all .otf files from any otf/ subdirectory
find /tmp/MPLUS_FONTS/fonts -type f -path '*/otf/*.otf' -exec cp {} .local/share/fonts/otf/MPlus/ \;

# Copy all .woff2 files from any otf/ subdirectory
find /tmp/MPLUS_FONTS/fonts -type f -path '*/webfonts/*.woff2' -exec cp {} .local/share/fonts/otf/MPlus/ \;

rm -rf /tmp/MPLUS_FONTS

chmod -R a+rX .local/share/fonts/ttf/MPlus
chmod -R a+rX .local/share/fonts/otf/MPlus
chmod -R a+rX .local/share/fonts/woff2/MPlus

fc-cache
