#!/bin/env bash

# Set up my computers from scratch.

if [[ "$OSTYPE" == *"linux"* ]]; then
	if [[ -f /etc/arch-release ]]; then
		echo "I'm $(cat /etc/arch-release)" 
		echo -e "Installing packages..." 
		echo "git (distributed control version system)" 
		echo "zsh (zsh shell)"
		echo "kitty (terminal emulator with graphics support and ligatures)" 
		echo "exa (ls replacement)" 
		echo "tldr (man lightweight)" 
		echo "diff-so-fancy (diff replacement)"
		echo "bat (cat replacement)"
		echo "ripgrep (grep replacement)" 
		echo "fzf (fuzzy finder)"
		echo "fd (find alternative)" 
		echo "fasd (command-line productiviy booster)"
		echo "emojify (emojis!)"
		echo "ranger (console file manager with graphics support)"
		sudo pacman -Syu --noconfirm git zsh kitty exa tldr diff-so-fancy bat ripgrep fzf fd fasd ranger ffmpegthumbnailer 
		sudo pamac emojify
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
	fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
	echo "I'm a MacOS"
fi
