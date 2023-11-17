#!/bin/bash -e

source ../functions.sh
./0-install_vsftpd.sh
./vsftpd_anonymous_login.sh
./vsftpd_localusers_login.sh
