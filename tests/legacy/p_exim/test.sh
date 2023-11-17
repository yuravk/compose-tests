#!/bin/bash -e

source ../functions.sh
./0-install_exim.sh
./10-test-sendmail.sh
./15_exim_smtp.sh
./20_exim_mta_helo-test.sh
./30_exim_mta_ehlo-test.sh
