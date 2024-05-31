#!/bin/bash -e

source ../functions.sh
./0-install_osbuild.sh
./1-verify_osbuild.sh
./osbuild_test.sh
