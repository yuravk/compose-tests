#!/bin/bash -e

source ../functions.sh
./10-systemctl_list_services.sh
./15-systemctl_list_non-native-services.sh
./20-systemctl_list-service-status.sh
./25-journalctl.sh
