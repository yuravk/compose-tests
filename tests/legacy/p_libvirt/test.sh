#!/bin/bash -e

source ../functions.sh
./0-install_libvirt.sh
./libvirt_virsh_test.sh
