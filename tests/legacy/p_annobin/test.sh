#!/bin/bash -e

source ../functions.sh
./0-install_annobin.sh
./10-test_annobin-gcc.sh
./20-test_annobin-gcc-c++.sh
