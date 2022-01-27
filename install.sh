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
		BACKUP="${DIR}/backup/${DATE}_$1.backup"
		mkdir -p $(dirname "$BACKUP")
		mv "$2" "${BACKUP}"
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
install "screenrc"		"${HOME}/.screenrc"
install "bashrc"		"${HOME}/.bashrc"
install "profile"		"${HOME}/.profile"

echo ""
if [[ "$(uname -a)" == CYGWIN* ]]; then
	echo "[Cygwin]"
	install "minttyrc"		"${HOME}/.minttyrc"

	USER_FONTDIR="${APPDATA}/../Local/Microsoft/Windows/Fonts/"
	SYS_FONTDIR="/cygdrive/c/Windows/Fonts/"

	if [[ ! -f "${SYS_FONTDIR}/Cica-Regular.ttf" ]] && \
		[[ ! -f "${USER_FONTDIR}/Cica-Regular.ttf" ]]; then
		echo -e "\e[31mERROR: minttyrc uses Cica-Regular.ttf but not found.\e[m"
		echo -e "\e[31m       You can download font from: https://github.com/miiton/Cica/releases/\e[m"
	fi
else
	echo "[not Cygwin]"
	install "rofi-config"	"${HOME}/.config/rofi/config"
fi

