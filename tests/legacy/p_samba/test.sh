#!/bin/bash -e

source ../functions.sh
./0-install_samba.sh
./samba_share_test.sh
