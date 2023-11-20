#!/bin/bash -e

source ../functions.sh
./0-install_sqlite.sh
./sqlite_1-create_db_table.sh
./sqlite_2-insert_table.sh
./sqlite_dump_db.sh
./sqlite_select_table.sh
