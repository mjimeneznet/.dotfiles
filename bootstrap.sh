#!/bin/env bash

# Set up my computers from scratch.

if [[ "$OSTYPE" == *"linux"* ]]; then
	if [[ -f /etc/arch-release ]]; then
		echo "I'm $(cat /etc/arch-release)" 
		echo "Installing packages..."
		sudo pacman -Syuq --noconfirm git zsh
		echo "Configuring git..."
		git config --global user.name "Manuel Jimenez"
		git config --global user.email "mjimenez@mjimenez.net"
		git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
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
		sudo pacman -Syuq --noconfirm kitty
		echo "Installing exa (ls replacement)..."
		sudo pacman -Syuq --noconfirm exa
		echo "Installing TL;DR (man lightweight)..."
		sudo pacman -Syu --noconfirm tldr
		echo "Installing diff-so-fancy (diff replacement)..."
		sudo pacman -Syu --noconfirm diff-so-fancy
		echo "Installing bat (cat replacement)..."
		sudo pacman -Syu --noconfirm bat
		echo "Installing ripgrep (grep replacement)..."
		sudo pacman -Syu --noconfirm ripgrep
		echo "Installing fzf (fuzzy finder)..."
		sudo pacman -Syu --noconfirm fzf
		echo "Installing fd (find alternative)..."
		sudo pacman -Syu --noconfirm fd
		echo "Installing Fasd (command-line productivity booster)..."
		sudo pacman -Syu --noconfirm fasd
		echo "Installing emojify (because I'm millenial)..."
		sudo pacman -Syu --noconfirm emojify
	fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
	echo "I'm a MacOS"
fi
