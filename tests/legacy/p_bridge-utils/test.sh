#!/bin/bash -e

source ../functions.sh
./00-install_bridge-utils.sh
./05-add_bridge.sh
./10-delete_bridge.sh
