#!/bin/bash -e

source ../functions.sh
./0-install_sshd.sh
./sshd_conn_test.sh
./sshd_user_login.sh
./sshd_user_login-with-key.sh
