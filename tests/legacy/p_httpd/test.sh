#!/bin/bash -e

source ../functions.sh
./0-install_httpd.sh
./httpd_basic_auth.sh
./httpd_centos_brand_server_tokens.sh
./httpd_centos_brand_welcome.sh
./httpd_php.sh
./httpd_servehtml.sh
./httpd_servehtml_ssl.sh
./httpd_vhost.sh
