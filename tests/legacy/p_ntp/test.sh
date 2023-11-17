#!/bin/bash -e

source ../functions.sh
./0-install_ntp.sh
./5-start-check.sh
./ntp_centos_servers.sh
