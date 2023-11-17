#!/bin/bash -e

source ../functions.sh
./00_install_tcpdump.sh
./01_tcpdump_nic.sh
./02_tcpdump_lo.sh
./03_tcpdump_lo_ipv6.sh
