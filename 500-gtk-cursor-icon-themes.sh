#!/bin/bash
set -e  # Exit on any error

installyay(){
    if pacman -Qi "$1" &> /dev/null; then
        echo "Package $1 is already installed."
    else
        yay -S --noconfirm --needed "$1"
    fi
}

set_gtk_thing() {
    local theme_name="$1"
    local thing="$2"
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0"
    local config_file="$config_dir/settings.ini"

    mkdir -p "$config_dir"

    # If the file doesn't exist, create it with [Settings] and the theme line
    if [[ ! -f "$config_file" ]]; then
        echo "[Settings]" > "$config_file"
        echo "$thing=$theme_name" >> "$config_file"
        return
    fi

    # Check if [Settings] section exists
    if ! grep -q "^\[Settings\]" "$config_file"; then
        # No [Settings] section - add it at the end and then the theme line
        echo -e "\n[Settings]\n$thing=$theme_name" >> "$config_file"
        return
    fi

    # [Settings] exists - now handle the gtk-icon-theme-name line
    if grep -q "^$thing=" "$config_file"; then
        # Replace the existing line
        sed -i "s/^$thing=.*/$thing=$theme_name/" "$config_file"
    else
        # Add the line right after [Settings]
        sed -i "/^\[Settings\]/a $thing=$theme_name" "$config_file"
    fi
}

echo "Installing Graphite GTK theme from AUR"
installyay graphite-gtk-theme 
echo "Setting Graphite Orange Dark Compact as default widget theme"
set_gtk_thing "Graphite-orange-Dark-compact" "gtk-theme-name"

echo "Installing Bibata cursor theme from AUR"
installyay bibata-cursor-theme

echo "Setting Bibata-Modern-Classic as default cursor theme"
set_gtk_thing "Bibata-Modern-Classic" "gtk-cursor-theme-name"
echo "Xcursor.theme: Bibata-Modern-Classic" >> "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources" 2>/dev/null || true

echo "Installing DarK icons from gitlab"
git clone https://gitlab.com/sixsixfive/DarK-icons.git /tmp/DarK-icons

ICON_FOLDER="$HOME/.local/share/icons"
mkdir -p "$ICON_FOLDER"
cd /tmp/DarK-icons

echo "Building SVG theme"
sh build_svg.sh

echo "Installing themes to $ICON_FOLDER..."
mv DarK-svg "$ICON_FOLDER"

cd -
rm -rf /tmp/DarK-icons

chmod -R a+rX "$ICON_FOLDER/DarK-svg"

echo "Setting DarK icons as default icon theme"
set_gtk_thing "DarK-svg" "gtk-icon-theme-name"
