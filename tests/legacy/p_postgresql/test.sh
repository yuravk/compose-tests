#!/bin/bash -e

source ../functions.sh
./0-install_postgresql.sh
./1-config-postgresql.sh
./postgresql_create_db.sh
./postgresql_create_user_test.sh
./postgresql_drop_db.sh
./postgresql_drop_user_test.sh
