#!/bin/bash -e

source ../functions.sh
./00-install_sysstat.sh
./05-iostat-cpu-basic.sh
./10-iostat-disk-basic.sh
./15-mpstat-basic.sh
./20-pidstat-basic.sh
./25-sa-tests.sh
