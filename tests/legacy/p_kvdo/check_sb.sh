#!/bin/bash
# This test will verify that kmod-kvdo is correctly signed with correct cert in the CA chain

t_Log "Running $0 -  Verifying that kmod-kvdo is correctly signed with correct cert"

arch=$(uname -m)

if [[ "$centos_ver" -ne 8 && "$arch" = "x86_64" ]] ; then
    t_InstallPackage kmod-kvdo
    for i in $(rpm -ql kmod-kvdo | grep "*.ko"); do
        modinfo $i | grep $kmod_sb_key
        t_CheckExitStatus $?
    done
else
  t_Log "versions is not 8 - or not x86_64 arch - aren't using kmod-kvdo"
  exit 0
fi

