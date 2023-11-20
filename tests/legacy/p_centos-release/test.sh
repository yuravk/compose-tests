#!/bin/bash -e

source ../functions.sh
./0-install_file.sh
./centos-release_centos-base_repos.sh
./centos-release_centos_gpg.sh
./centos-release_issue.sh
./centos-release_os-release.sh
./centos-release_release_compat_symlinks.sh
./centos-release_system_release.sh
