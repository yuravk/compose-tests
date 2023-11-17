#!/bin/bash -e

source ../functions.sh
./0-install_snmpd.sh
./snmpv1_test.sh
./snmpv2c_test.sh
./snmpv3_test.sh
