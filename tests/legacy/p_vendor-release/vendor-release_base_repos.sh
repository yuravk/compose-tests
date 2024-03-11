#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - $os_name repos sanity test."

grep "name=$os_name" /etc/yum.repos.d/*.repo >/dev/null 2>&1

t_CheckExitStatus $?
