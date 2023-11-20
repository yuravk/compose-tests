#!/bin/bash -e

source ../functions.sh
./00_centos_repos.sh
./01_dist_release_check.sh
./03_print_booted_kernel.sh
./05_stop_yumupdatesd.sh
./10_remove_32bitpkgs.sh
./15_list_repos.sh
./20_upgrade_all.sh
./30_dns_works.sh
./40_update_hosts.sh
./50_test_comps.sh
