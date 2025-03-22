#!/bin/bash

installpac(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo pacman -S --noconfirm --needed $1
}

installyay(){
    if pacman -Qi $1 &> /dev/null; then
        echo "Package {$1} is already installed."
    else
        sudo yay -S --noconfirm --needed $1
}


list=(
python
python-black
python-colour
python-conda
python-cvxopt
python-distutils-extra
python-httplib2
python-ipykernel
python-matplotlib
python-numpy
python-pandas
python-pillow
python-pip
python-plotly
python-poetry
python-scipy
python-seaborn
python-selenium
python-setuptools-git
python-sphinx_rtd_theme
python-trimesh
texlive-latexextra
)

for name in "${list[@]}" ; do
	installpac $name
done

echo "Installing AUR packages"

list_yay=(
python-collada
python-kaleido-bin
python-pywavefront
python-uaibot
)

for name in "${list_yay[@]}" ; do
	installyay $name
done
