#!/bin/bash
set -e
PGVERSION=$(sed -n "/PACKAGE_VERSION=/{s/.*=//;s/'//g;p}" /host/pgbuilder/postgres/configure | grep -oE '^[0-9]+')
dnf -y module disable postgresql
cp localpg.repo /etc/yum.repos.d/
dnf -y install postgresql${PGVERSION}-contrib sudo
echo "export PGVERSION=${PGVERSION}
export PATH=/usr/pgsql-${PGVERSION}/bin:\$PATH" >~postgres/.pgsql_profile
