#!/bin/bash -e

source ../functions.sh
./0-install_mod_wsgi.sh
./10-test_mod_wsgi.sh
./20-remove_mod_wsgi.sh
