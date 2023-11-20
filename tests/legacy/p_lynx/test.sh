#!/bin/bash -e

source ../functions.sh
./0-install_lynx.sh
./lynx_default_page_centos_test.sh
./lynx_dump_page_test.sh
