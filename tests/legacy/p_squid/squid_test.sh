#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - Squid test."

URL="http://mirror.centos.org/"
CHECK_FOR="timestamp"

squidclient -T 2 ${URL} | grep "${CHECK_FOR}"

t_CheckExitStatus $?
