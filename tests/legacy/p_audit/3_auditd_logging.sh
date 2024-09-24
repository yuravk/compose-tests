#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>
if [ $CONTAINERTEST -eq 1 ]; then
	    echo "Skipping this test ..."
else
t_Log "Running $0 -  check if audit log is not empty."

[[ -s /var/log/audit/audit.log ]] 

t_CheckExitStatus $?
fi
