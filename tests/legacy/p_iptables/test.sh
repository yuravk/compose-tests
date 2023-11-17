#!/bin/bash -e

source ../functions.sh
./iptables_add-remove_test.sh
./iptables_default_rules.sh
./iptables_function-check_test.sh
./iptables_kmod_loaded.sh
