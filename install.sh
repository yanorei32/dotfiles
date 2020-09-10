#!/bin/bash

DIR=$(cd $(dirname $0) && pwd)

DATE=$(date "+%Y%m%d_%H%M%S")

function install () {
	if [[ $# -ne 2 ]]; then
		echo "script error"
		exit 1
	fi

	echo "install $1 -> $2"

	# create install dir
	mkdir -p $(dirname "$2")

	# backup
	if [[ -f "$2" ]]; then
		BACKUP="backup/${DATE}_$1.backup"
		mkdir -p $(dirname "$BACKUP")
		mv "$2" "${DIR}/${BACKUP}"
		echo " - backup created ${BACKUP}"
	fi

	# install
	ln -s "${DIR}/$1" "$2"

	if [[ $? -ne 0 ]]; then
		echo " - installation failed"
	fi
}

echo "[Basic]"
install "vimrc"			"${HOME}/.vimrc"
install "bashrc"		"${HOME}/.bashrc"
install "profile"		"${HOME}/.profile"

echo ""
if [[ "$(uname -a)" == CYGWIN* ]]; then
	echo "[Cygwin]"
	install "minttyrc"		"${HOME}/.minttyrc"
else
	echo "[not Cygwin]"
	install "rofi-config"	"${HOME}/.config/rofi/config"
fi

