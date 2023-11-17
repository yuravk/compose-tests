#!/bin/bash -e

source ../functions.sh
./0_install_openssl.sh
./10-openssl-cert-test.sh
