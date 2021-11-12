#!/bin/sh
echo "################################################################"
echo "Cloning Personal Setup repo"
git clone https://github.com/n0k0m3/Personal-Setup --depth=1
cd Personal-Setup
echo "################################################################"
echo "Install ZSH and Oh-My-Zsh"
./install_zsh.sh

# Install powerline fonts
echo "################################################################"
echo "Install powerline fonts"
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# Install ZSH Plugins
echo "################################################################"
echo "Install ZSH Plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate

# Automatic copy config
echo "################################################################"
echo "Copy .dotfiles configs"
cp .dotfiles/ ~ -r