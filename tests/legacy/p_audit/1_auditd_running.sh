#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 -  check if auditd is running."

if [ "$CONTAINERTEST" -eq 1 ] ; then
    echo "Skipping this test ..."
else
    service auditd status > /dev/null 2>&1
    t_CheckExitStatus $?
fi
