#!/bin/bash -e

source ../functions.sh
./0-install_rrdtool.sh
./rrdtool_test.sh
