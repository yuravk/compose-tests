#!/bin/bash -e

source ../functions.sh
./0-install_autofs.sh
./10-autofs-nfs-mount.sh
