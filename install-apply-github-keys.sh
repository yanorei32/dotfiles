#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "$0 [username]"
	exit 1
fi

if ! type curl > /dev/null 2>&1; then
	echo "curl is required"
	exit 1
fi

if ! type crontab > /dev/null 2>&1; then
	echo "crontab is required"
	exit 1
fi

DIR=$(cd $(dirname $0) && pwd)
SCRIPT="${DIR}/apply-github-keys.sh"
CRONTAB="${DIR}/crontab"

echo "download pubkey..."
STATUSCODE=$( \
	curl -sS \
		-w '%{http_code}' \
		"https://github.com/$1.keys" \
		-o /dev/null \
)

if [[ "${STATUSCODE}" != "200" ]]; then
	echo "download error. invalid GitHub username $1"
	exit 1
fi

crontab -l > "${CRONTAB}"

if [[ "$(cat ${CRONTAB} | grep "${SCRIPT}" | wc -l)" != "0" ]]; then
	echo "already installed. do nothing."
	exit 1
fi

echo "@reboot /bin/bash ${SCRIPT} $1" | tee -a "${CRONTAB}"
echo "0 * * * * /bin/bash ${SCRIPT} $1" | tee -a "${CRONTAB}"

crontab "${CRONTAB}"

if [[ $? -ne 0 ]]; then
	echo "failed to install crontab configure"
fi

rm "${CRONTAB}"

