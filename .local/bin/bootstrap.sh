#!/bin/env bash

# Set up my computers from scratch.
echo -e "Installing packages..." 
echo "git (distributed control version system)" 
echo "zsh (zsh shell)"
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
		
PACKAGES="git zsh tldr bat ripgrep fd-find fasd ranger ffmpegthumbnailer"
##Manually
# exa https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
# diff-so-fancy https://github.com/so-fancy/diff-so-fancy/archive/v1.2.7.zip
# fd/fd-find
#fzf git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

if [[ "$OSTYPE" == *"linux"* ]]; then
	if [[ $(lsb_release -i | cut -f 2) == *"Ubuntu"* ]]; then
		sudo apt install $PACKAGES
	fi

	if [[ -f /etc/arch-release ]]; then
		#echo "I'm $(cat /etc/arch-release)" 
		#sudo pacman -Syu --noconfirm git zsh kitty exa tldr diff-so-fancy bat ripgrep fzf fd fasd ranger ffmpegthumbnailer 
		#sudo pamac emojify
		#echo "Configuring git..."
		#git config --global user.name "Manuel Jimenez"
		#git config --global user.email "mjimenez@mjimenez.net"
		#git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
		#if [[ !$0 == "zsh" ]]; then
		#	echo "Setting up ZSH as default shell..."
		#	chsh -s "$(which zsh)"
		#fi
		#if [[ ! -d ~/.zplug ]]; then
		#	echo "Installing zplug..."
		#	curl -sL --proto-redir -all https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
		#fi
		#if [[ ! -d ~/.local/share/fonts/NerdFonts ]]; then
		#	echo "Installing extra fonts..."
		#	git clone https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts && bash /tmp/nerd-fonts/install.sh -A	
		#fi
		echo arch
	fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
	echo "I'm a MacOS"
fi
