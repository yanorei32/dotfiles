# set locale
export LANG=$(locale -uU)

# read .bashrc if run by bash
if [[ -n "${BASH_VERSION}" ]]; then
	if [ -f "${HOME}/.bashrc" ]; then
		source "${HOME}/.bashrc"
	fi
fi

