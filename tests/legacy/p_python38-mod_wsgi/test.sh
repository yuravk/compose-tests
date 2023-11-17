#!/bin/bash -e

source ../functions.sh
./0-install_python38-mod_wsgi.sh
./10-test_python38-mod_wsgi.sh
./20-remove_python38-mod_wsgi.sh
