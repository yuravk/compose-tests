#!/bin/bash -e

source ../functions.sh
./0-install_file.sh
./vendor-release_base_repos.sh
./vendor-release_gpg.sh
./vendor-release_issue.sh
./vendor-release_os-release.sh
./vendor-release_release_compat_symlinks.sh
./vendor-release_system_release.sh
