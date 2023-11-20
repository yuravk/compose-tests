#!/bin/bash -e

source ../functions.sh
./0_install_auditd.sh
./1_auditd_running.sh
./2_auditd_generate-events.sh
./3_auditd_logging.sh
