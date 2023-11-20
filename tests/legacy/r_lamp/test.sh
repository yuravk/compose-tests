#!/bin/bash -e

source ../functions.sh
./0_lamp_install.sh
./1_lamp_check.sh
./40_basic_lamp.sh
./45_basic_lamp_mysql55.sh
./50_lamp_check_mysql55.sh
