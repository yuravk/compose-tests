#!/bin/bash -e

source ../functions.sh
./0-install_shadow_utils
./10-basic_test
./11-useradd_tests
./12-usermod_tests
./13-chpasswd_tests
./14-newusers_tests
./15-lastlog_tests
./19-userdel_tests
./20-chage_tests
./30-groupadd_tests
./31-gpasswd_tests
./32-groupmems_tests
./33-newgrp_tests
./34-groupmod_tests
./35-grpck-tests
./36-groupdel-tests
./37-grpconv-tests
./38-grpunconv-tests
./39-sg_tests
./40-pwck_tests
./41-pwconv_tests
./42-pwunconv_tests
./99-cleanup
