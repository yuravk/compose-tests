#!/bin/bash -e

source ../functions.sh
./0-install_bc.sh
./10-bc-installed-test.sh
./20-bc-test-simple-calculation.sh
./bc-test-basic-functionalities.sh
./bc-test-installation.sh
