#!/bin/bash -e

source ../functions.sh
./0-install_mailman.sh
./mailman_test.sh
