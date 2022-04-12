#!/bin/sh
echo "################################################################"
echo "Cloning Personal Setup repo"
git clone https://github.com/n0k0m3/Personal-Setup --depth=1
cd Personal-Setup/Setting_up_Arch

# Automatic copy config
echo "################################################################"
echo "Copy .dotfiles configs"
cp -r -a .dotfiles/. ~
