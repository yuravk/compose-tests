#!/bin/bash -e

source ../functions.sh
./0-install-python.sh
./10-test_python.sh
./20-python-mysql-test.sh
./25-python-mysql55-test.sh
