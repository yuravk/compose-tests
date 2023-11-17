#!/bin/bash -e

source ../functions.sh
./0-install_perl.sh
./10-test_perl.sh
./20-run_perl_script.sh
