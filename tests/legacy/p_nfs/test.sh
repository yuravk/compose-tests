#!/bin/bash -e

source ../functions.sh
./0-install_nfs.sh
./nfs_share_rw.sh
