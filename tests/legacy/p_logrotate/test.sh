#!/bin/bash -e

source ../functions.sh
./0-install_logrotate.sh
./logrotate_test.sh
