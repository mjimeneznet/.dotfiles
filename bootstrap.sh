#!/bin/bash

# Set up my computers from scratch.

if [[ "$OSTYPE" == *"linux"* ]]; then
	if [[ -f /etc/arch-release ]]; then
		echo "I'm $(cat /etc/arch-release)" 
		echo "Installing packages..."
		sudo pacman -Syu
		sudo packan -Syu git zsh
		echo "Setting up ZSH as default shell..."
		chsh -s "$(which zsh)"
	fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
	echo "I'm a MacOS"
fi
