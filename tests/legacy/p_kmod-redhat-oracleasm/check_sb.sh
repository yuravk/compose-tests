#!/bin/bash
# This test will verify that kmod-redhat-oracleasm is correctly signed with correct cert in the CA chain

t_Log "Running $0 -  Verifying that kmod-redhat-oracleasm is correctly signed with correct cert"

arch=$(uname -m)

if [[ $os_name == "centos" ]]; then
  t_Log "CentOS detected, exiting"
  exit 0
fi

if [[ "$centos_ver" -eq 8 && "$arch" = "x86_64" ]] ; then
    t_InstallPackage kmod-redhat-oracleasm
    for i in $(rpm -ql kmod-redhat-oracleasm | grep "*.ko"); do
        modinfo $i | grep $kmod_sb_key
        t_CheckExitStatus $?
    done
else
  t_Log "versions is not 8 - or not x86_64 arch - aren't using kmod-redhat-oracleasm"
  exit 0
fi

