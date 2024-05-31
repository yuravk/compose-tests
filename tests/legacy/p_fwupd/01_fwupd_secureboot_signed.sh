#!/bin/bash
# This test will verify that fwupd is correctly signed with correct cert in the CA chain

t_Log "Running $0 -  Verifying that fwupd is correctly signed with correct cert"

arch=$(uname -m)

if [[ "$centos_ver" -ge 7 && "$arch" = "x86_64" ]] ; then
  t_InstallPackage pesign fwupd
  pesign --show-signature --in /usr/libexec/fwupd/efi/fwupdx64.efi.signed|egrep -q "$grub_sb_token"
  t_CheckExitStatus $?
else
  t_Log "previous versions than CentOS 7 - or not x86_64 arch - aren't using secureboot ... skipping"
  exit 0
fi

