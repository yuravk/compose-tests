#!/bin/bash -e

source ../functions.sh
./00-install_freeradius.sh
./10_radiusd_test.sh
