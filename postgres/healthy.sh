#!/bin/bash
echo 'set -e
source ~/.bash_profile
pg_isready' | sudo -upostgres bash
