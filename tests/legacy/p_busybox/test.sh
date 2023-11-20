#!/bin/bash -e

source ../functions.sh
./00_install_busybox.sh
./10_test_busybox.sh
./20_functiontest_busybox.sh
