#!/bin/bash -e

source ../functions.sh
./0-install_amanda.sh
./amanda-server_test.sh
