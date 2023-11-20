#!/bin/bash -e

source ../functions.sh
./yum_bugtracker.sh
./yum_distroverpkg.sh
./yum_remove_pkg_test.sh
