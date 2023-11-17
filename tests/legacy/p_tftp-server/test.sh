#!/bin/bash -e

source ../functions.sh
./0-install_tftp-server.sh
./10-tftp-server_get-test.sh
./20-tftp-server_put-test.sh
