#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>

if [ "$CONTAINERTEST" -eq "1" ]; then
    t_Log "Running in container -> SKIP"
    exit 0
fi

if [ "$centos_ver" -ne "8" -a "$centos_ver" -ne "9" ]; then
  t_Log "non 8 or 9 => SKIPPING"
  exit 0
fi

t_Log "Running $0 - installing beakerlib"
t_InstallPackage git make patch python3-lxml
pushd /tmp
git clone https://github.com/beakerlib/beakerlib
cd beakerlib
make
make install
popd
