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
        sudo yay -S --noconfirm --needed $1
    fi
}

list=(
sdl2_ttf
ttf-dejavu
ttf-fira-code
ttf-font-awesome
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

echo "Installing MPlus font from github"
mkdir -p .local/share/fonts/ttf/MPlus
mkdir -p .local/share/fonts/otf/MPlus

git clone https://github.com/coz-m/MPLUS_FONTS.git /tmp/MPLUS_FONTS
cp /tmp/MPLUS_FONTS/fonts/ttf/* .local/share/fonts/ttf/MPlus
cp /tmp/MPLUS_FONTS/fonts/otf/* .local/share/fonts/otf/MPlus
rm -rf /tmp/MPLUS_FONTS
chmod -R a+rX .local/share/fonts/ttf/MPlus
chmod -R a+rX .local/share/fonts/otf/MPlus

fc-cache
