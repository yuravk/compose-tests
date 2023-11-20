#!/bin/bash -e

source ../functions.sh
./network_device_test.sh
./networking_enabled_test.sh
./networking_vlan_test.sh
