#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - LSB $os_name branding check."

lsb_release -i | grep -q "$os_name" && \
lsb_release -d | grep -q "$os_name"

t_CheckExitStatus $?
