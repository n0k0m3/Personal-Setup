#!/bin/sh

sh_c='sh -c'
if [ "$user" != 'root' ]; then
	if command_exists sudo; then
		sh_c='sudo -E sh -c'
	elif command_exists su; then
		sh_c='su -c'
	else
		cat >&2 <<-'EOF'
		Error: this installer needs the ability to run commands as root.
		We are unable to find either "sudo" or "su" available to make this happen.
		EOF
		exit 1
	fi
fi

get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}

lsb_dist=$( get_distribution )
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

case "$lsb_dist" in

    ubuntu|debian|raspbian)
        sudo apt-get update && sudo apt-get install zsh curl -y
    ;;

    endeavouros|arch)
        sudo pacman -S zsh curl
    ;;
	
	centos|fedora|rhel)
		if [ "$lsb_dist" = "fedora" ]; then
			pkg_manager="dnf"
		else
			pkg_manager="yum"
		fi
		(
			$sh_c "$pkg_manager install -y -q zsh"
		)
	;;
			
esac

echo ""
echo "Next step will install Oh My ZSH and set ZSH as default. Answer Y and when it's done type \"exit\""
read -n1 -r -p "Press any key to continue or Ctrl-C to cancel..." key

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# agnoster theme with font. Note Color: Solarized Dark; Font:Powerline-patched Meslo

# Add PATH to .zshrc
echo -e "export PATH=\$HOME/.local/bin:\$HOME/bin:/usr/local/bin:\$PATH\n$(cat ~/.zshrc)" > ~/.zshrc

# Change theme to agnoster
sed -i -e 's/robbyrussell/agnoster/g' ~/.zshrc

# Fix username@hostname terminal
echo -e "DEFAULT_USER=\`whoami\`\n$(cat ~/.zshrc)" > ~/.zshrc

# Install powerline fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts