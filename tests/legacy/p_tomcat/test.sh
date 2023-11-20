#!/bin/bash -e

source ../functions.sh
./0-install_tomcat.sh
./1-config_tomcat.sh
./tomcat_manager_test.sh
./tomcat_test.sh
