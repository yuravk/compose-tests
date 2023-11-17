#!/bin/bash -e

source ../functions.sh
./0-install_spamassassin.sh
./spamassassin_test.sh
