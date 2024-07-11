#!/bin/bash
set -ex
git submodule set-url pgbuilder/postgres "${PGBUILDER_REMOTE}"
cd postgres
git submodule init
git submodule update
git fetch
if ! git checkout "${PGBUILDER_BRANCH}"; then
	git checkout "origin/${PGBUILDER_BRANCH}" -b "${PGBUILDER_BRANCH}"
else
	git checkout "${PGBUILDER_BRANCH}"
	git reset --hard "origin/${PGBUILDER_BRANCH}"
fi
git remote get-url origin
git branch
git show --stat
