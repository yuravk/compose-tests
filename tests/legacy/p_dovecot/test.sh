#!/bin/bash -e

source ../functions.sh
./0-install_dovecot.sh
./1-config_dovecot.sh
./dovecot_imap_login.sh
./dovecot_pop3_login.sh
