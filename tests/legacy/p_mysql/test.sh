#!/bin/bash -e

source ../functions.sh
./0-install_mysqld.sh
./10_mysqld_conn_test.sh
./15_mysqld_create_db.sh
./20_mysqld_drop_db.sh
./25_mysqld_grant_test.sh
./50_switch_to_mysql55.sh
./60_mysqld55_conn_test.sh
./65_mysqld55_create_db.sh
./70_mysqld55_drop_db.sh
./75_mysqld55_grant_test.sh
