#!/bin/bash -e

source ../functions.sh
./0_install_php-cli.sh
./10-php-test.sh
./20-php-mysql-test.sh
./25-php-mysql55-test.sh
