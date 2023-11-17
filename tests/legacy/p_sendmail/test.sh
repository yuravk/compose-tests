#!/bin/bash -e

source ../functions.sh
./0-install_sendmail.sh
./10_sendmail_smtp.sh
./15-test-sendmail.sh
./20_sendmail_mta.sh
./30_sendmail_mta_ehlo.sh
