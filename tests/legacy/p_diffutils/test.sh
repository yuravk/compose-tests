#!/bin/bash -e

source ../functions.sh
./0_install_diffutils
./20-diff-tests
./30-diff3-tests
./40-sdiff-tests
