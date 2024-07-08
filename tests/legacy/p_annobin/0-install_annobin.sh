#!/bin/bash
# Author: Neal Gompa <ngompa@datto.com>

# Install annobin and gcc
t_Log "Running $0 - installing annobin and gcc."

package=annobin
if [ "$centos_ver" -ge "10" ]; then
  package=annobin-annocheck
fi

t_InstallPackage $package redhat-rpm-config gcc gcc-c++
