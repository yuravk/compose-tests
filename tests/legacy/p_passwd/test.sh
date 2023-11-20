#!/bin/bash -e

source ../functions.sh
./0_install_passwd
./10_passwd_basic_test
./20_root_tests
./30_user_tests
