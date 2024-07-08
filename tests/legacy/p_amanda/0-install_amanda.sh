#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>
# Christoph Galuschka <tigalch@tigalch.org>

t_Log "$0 - installing amanda system"

t_InstallPackage amanda amanda-server amanda-client
id -u amandabackup &>/dev/null || useradd amandabackup 
