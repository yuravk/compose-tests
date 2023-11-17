#!/bin/bash -e

source ../functions.sh
./0-install_postfix.sh
./10_postfix_smtp.sh
./20_postfix_mta.sh
./30_postfix_mta_ehlo.sh
./40_postfix_sasl.sh
./50_postfix_tls.sh
