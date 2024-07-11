#!/bin/bash
set -e
export DISTRO_RELEASE=${DISTRO_RELEASE:-rockylinux}
export DISTRO=${DISTRO:-8}
rm -f build/rpms/*.rpm
docker-compose down
docker-compose up pgbuilder --no-deps --exit-code-from pgbuilder
docker-compose up -d postgres --no-deps
docker-compose up pgtester --no-deps --exit-code-from pgtester
docker-compose up pg_tps_optimizer --no-deps --exit-code-from pg_tps_optimizer
