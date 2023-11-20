#!/bin/bash -e

source ../functions.sh
./0_install_libbpf.sh
./10_test_bcc_tools.sh
