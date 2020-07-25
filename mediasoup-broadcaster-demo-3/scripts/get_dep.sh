#!/usr/bin/env bash

set -e

PROJECT_PWD=${PWD}
DEP=$1

current_dir_name=${PROJECT_PWD##*/}
if [ "${current_dir_name}" != "mediasoup-broadcaster-demo" ] && [ "${current_dir_name}" != "v3-mediasoup-broadcaster-demo" ] ; then
	echo ">>> [ERROR] $(basename $0) must be called from root directory" >&2
	exit 1
fi

function get_dep()
{
	GIT_REPO="$1"
	GIT_TAG="$2"
	DEST="$3"

	echo ">>> [INFO] getting dep '${DEP}' ..."

	if [ -d "${DEST}" ] ; then
		echo ">>> [INFO] deleting ${DEST} ..."
		git rm -rf --ignore-unmatch ${DEST} > /dev/null
		rm -rf ${DEST}
	fi

	echo ">>> [INFO] cloning ${GIT_REPO} ..."
	git clone ${GIT_REPO} ${DEST}

	cd ${DEST}

	echo ">>> [INFO] setting '${GIT_TAG}' git tag ..."
	git checkout --quiet ${GIT_TAG}
	set -e

	echo ">>> [INFO] adding dep source code to the repository ..."
	rm -rf .git
	git add .

	echo ">>> [INFO] got dep '${DEP}'"

	cd ${PROJECT_PWD}
}

function get_libmediasoupclient()
{
	GIT_REPO="https://github.com/versatica/libmediasoupclient.git"
	GIT_TAG="v3"
	DEST="deps/libmediasoupclient"

	get_dep "${GIT_REPO}" "${GIT_TAG}" "${DEST}"
}

function get_cpr()
{
	GIT_REPO="https://github.com/whoshuu/cpr"
	GIT_TAG="master"
	DEST="deps/cpr"

	get_dep "${GIT_REPO}" "${GIT_TAG}" "${DEST}"
}
case "${DEP}" in
	'-h')
		echo "Usage:"
		echo "  ./scripts/$(basename $0) [cpr|libmediaoupclient]"
		echo
		;;
	cpr)
		get_cpr
		;;
	libmediasoupclient)
		get_libmediasoupclient
		;;
	*)
		echo ">>> [ERROR] unknown dep '${DEP}'" >&2
		exit 1
esac

if [ $? -eq 0 ] ; then
	echo ">>> [INFO] done"
else
	echo ">>> [ERROR] failed" >&2
	exit 1
fi
