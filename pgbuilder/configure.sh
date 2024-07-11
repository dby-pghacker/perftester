#!/bin/bash
set -ex

function getremote() {
	LOCALCLONE=$1

	cd "${LOCALCLONE}"
	git remote get-url origin
}

function getrevision() {
	LOCALCLONE=$1

	cd "${LOCALCLONE}"
	git branch 2>/dev/null
}

function downloadsource() {
	URL=$1
	LOCALSOURCE=/root/rpmbuild/SOURCES/$(basename "$URL")
	mkdir -p "$(dirname "${LOCALSOURCE}")"
	curl -L "${URL}" -o "${LOCALSOURCE}"
}

function get_pgpackageversion() {
	PGLOCALCLONE=$1
	sed -n "/PACKAGE_VERSION=/{s/.*=//;s/'//g;p}" "${PGLOCALCLONE}/configure"
}

function get_pgversion() {
	PGLOCALCLONE=$1
	get_pgpackageversion "${PGLOCALCLONE}" | grep -oE '^[0-9]+'
}

function gen_rpm_macros() {
	PGLOCALCLONE=$1
	PGGITREPO=$2
	PGGITSOURCE=$3

	PGPACKAGEVERSION=$(get_pgpackageversion "${PGLOCALCLONE}")
	PGMAJORVERSION=$(get_pgversion "${PGLOCALCLONE}")
	echo "%pgmajorversion ${PGMAJORVERSION}
  %packageversion ${PGMAJORVERSION}0
  %prevmajorversion $((PGMAJORVERSION - 1))
  %url ${PGGITREPO}
  %source0 ${PGGITSOURCE}
  %pgversion ${PGPACKAGEVERSION}" >~/.rpmmacros
}

grep -E '^(NAME|VERSION)=' /etc/os-release

cd "$(dirname "$0")"
BASEDIR=$PWD

PGLOCALCLONE=${PGLOCALCLONE:-/host/pgbuilder/postgres}
ls -a "${PGLOCALCLONE}"

# Postgres
PGVERSION=$(get_pgversion "${PGLOCALCLONE}")
echo "PGVERSION: $PGVERSION"

PGGITORIGIN=$(getremote "$PGLOCALCLONE")
PGGITTAG=$(getrevision "$PGLOCALCLONE")

echo "Building RPMs for ${PGGITTAG}"

PGGITSOURCE=${PGGITORIGIN}/archive/postgres.tar.gz
gen_rpm_macros "${PGLOCALCLONE}" "${PGGITORIGIN}" "${PGGITSOURCE}"
downloadsource "https://www.postgresql.org/files/documentation/pdf/${PGVERSION}/postgresql-${PGVERSION}-A4.pdf"
tar -zcf "/root/rpmbuild/SOURCES/$(basename "${PGGITSOURCE}")" -C "${PGLOCALCLONE}" .
cp "${BASEDIR}/sources/postgresql-${PGVERSION}"* /root/rpmbuild/SOURCES
