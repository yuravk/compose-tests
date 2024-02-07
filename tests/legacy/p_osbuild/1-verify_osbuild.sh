#!/bin/bash
# Author: Yuriy Kohut <ykohut@almalinux.org>

t_Log "Verify that the installation works"

systemctl enable --now osbuild-composer.socket

systemctl restart osbuild-composer

composer-cli status show
t_CheckExitStatus $?