#!/bin/bash -e

source ../functions.sh
./0_install_gzip.sh
./10-C5-test-binaries
./10-test-binaries
./20-gzip-test
./40-gcmp-gdiff-tests
./50-zgrep-tests
./60-zforce-tests
./70-zless-tests
./80-zmore-tests
./90-znew-tests
