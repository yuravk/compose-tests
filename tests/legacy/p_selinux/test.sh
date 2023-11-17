#!/bin/bash -e

source ../functions.sh
./0_install_tools.sh
./selinux_alerts.sh
./selinux_enforce.sh
./selinux_policy_mismatch.sh
