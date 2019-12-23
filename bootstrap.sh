#!/bin/bash

# Set up my computers from scratch.

if [[ "$OSTYPE" == *"linux"* ]]; then
	if [[ -f /etc/arch-release ]]; then
		echo "I'm $(cat /etc/arch-release)" 
		echo "Installing packages..."
		sudo pacman -Syuq --noconfirm git zsh 2>&1 > /dev/null
		if [[ !$0 == "zsh" ]]; then
			echo "Setting up ZSH as default shell..."
			chsh -s "$(which zsh)"
		fi
		if [[ ! -d ~/.zplug ]]; then
			echo "Installing zplug..."
			curl -sL --proto-redir -all https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
		fi
		if [[ ! -d ~/.local/share/fonts/NerdFonts ]]; then
			echo "Installing extra fonts..."
			git clone https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts && bash /tmp/nerd-fonts/install.sh -A	
		fi
		echo "Installing Kitty terminal..."
		sudo pacman -Syuq --noconfirm kitty 2>&1 > /dev/null
		echo "Installing exa (ls replacement"
		sudo pacman -Syuq --noconfirm exa 2>&1 > /dev/null
	fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
	echo "I'm a MacOS"
fi
