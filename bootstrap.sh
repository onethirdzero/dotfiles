#!/bin/bash

# https://stackoverflow.com/a/677212/10667555
requires () {
	command -v "${1}" >/dev/null 2>&1 || { echo >&2 "Requires \"${1}\" but it's not installed. Aborting."; exit 1; }
}

requires git

# Ensure chezmoi.
if ! command -v chezmoi >/dev/null; then
	sh -c "$(wget -qO- chezmoi.io/get)" || sh -c "$(curl -fsLS chezmoi.io/get)"

	# Set up dotfiles.
	chezmoi init --apply --verbose git@github.com:onethirdzero/dotfiles.git
fi

# Ensure zgen.
if [ ! -d "${HOME}/.zgen" ]; then
	git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# Ensure zsh.
if [ -n "${ZSH_VERSION}" ]; then
	echo "We're not in zsh. Installing zsh"

	echo "Assuming we're on a Ubuntu host"
	sudo apt update
	sudo apt install zsh

	echo "Starting a zsh shell"
	zsh
fi

