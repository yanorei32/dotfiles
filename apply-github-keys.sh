#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "$0 [username]"
	exit 1
fi

if ! type curl > /dev/null 2>&1; then
	echo "curl is required"
	exit 1
fi

DIR=$(cd $(dirname $0) && pwd)

AUTHORIZED_KEYS="${HOME}/.ssh/authorized_keys"
GIT_AUTHORIZED_KEYS="${DIR}/git_authorized_keys"
ADD_AUTHORIZED_KEYS="${DIR}/additional_authorized_keys"

mkdir -p $(dirname ${AUTHORIZED_KEYS})

echo "get github keys..."
STATUSCODE=$( \
	curl -sS \
		-w '%{http_code}' \
		"https://github.com/$1.keys" \
		-o ${GIT_AUTHORIZED_KEYS} \
)

if [[ "${STATUSCODE}" != "200" ]]; then
	echo "download error"
	exit 1
fi

cat "${GIT_AUTHORIZED_KEYS}" > "${AUTHORIZED_KEYS}"

if [[ -e "${ADD_AUTHORIZED_KEYS}" ]]; then
	echo "append addtional keys.."
	cat "${ADD_AUTHORIZED_KEYS}" >> "${AUTHORIZED_KEYS}"
fi

rm "${GIT_AUTHORIZED_KEYS}"

