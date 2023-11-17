#!/bin/bash -e

source ../functions.sh
./0_install_lftp.sh
./10_lftp_http_test.sh
./20_lftp_ftp.sh
