#!/bin/bash
# Author: Christoph Galuschka <christoph.galuschka@chello.at>

t_Log "Running $0 -  install package nmap"
t_InstallPackage nmap

# The nmap tests look for the open ssh port, don't rely on an earlier test
# (or the guest image) having started sshd
t_InstallPackage openssh-server
t_ServiceControl sshd start

