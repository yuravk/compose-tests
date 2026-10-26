#!/bin/bash

t_Log "Running $0 - installing python3-mod_wsgi"

if [[ $centos_ver -lt 8 ]]; then
    t_Log "python3-mod_wsgi doesn't exist before CentOS 8 -> SKIP"
    exit 0
fi

# Also httpd (mod_wsgi pulls in only httpd-core, which has no httpd.service),
# mod_ssl and curl for the https check: don't rely on an earlier test having
# installed them
t_InstallPackage python3-mod_wsgi httpd mod_ssl curl
