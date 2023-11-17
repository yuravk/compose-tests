#!/bin/bash -e

source ../functions.sh
./0_install_nmap.sh
./nmap_test_eth0.sh
./nmap_test_lo.sh
