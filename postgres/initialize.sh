#!/bin/bash
set -e
source ~/.bash_profile
if [ ! -f $PGDATA/PG_VERSION ]; then
	initdb
	echo "listen_addresses = '*'" >>"${PGDATA}/postgresql.conf"
	echo "max_connections = 1000" >>"${PGDATA}/postgresql.conf"
	echo 'host all all 0.0.0.0/0 trust' >>"${PGDATA}/pg_hba.conf"
fi
pg_isready || pg_ctl start
for ((i = 0; i < 10; i++)); do
	pg_isready && break
	sleep 1
done
pg_isready
for SCRIPT in /host/postgres/schema/*.sql; do
	[ -f "${SCRIPT}" ] && psql -c "${SCRIPT}"
done
