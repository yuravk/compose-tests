#!/bin/bash
# Author: Christoph Galuschka <tigalch@tigalch.org>

t_Log "Running $0 -  install package enscript, ghostscript and pdftotext"

# Workarround for post scriptlet non-fatal errors
yum -y remove bitstream-vera* liberation*
#
fonts_pkgs="fontconfig"
[ $centos_ver -ne 10 ] && fonts_pkgs="${fonts_pkgs} @fonts"
t_InstallPackage ${fonts_pkgs}
t_InstallPackage enscript ghostscript poppler-utils

