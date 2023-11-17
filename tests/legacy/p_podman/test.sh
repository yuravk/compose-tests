#!/bin/bash -e

source ../functions.sh
./00_install_podman.sh
./10_podman_tests.sh
./15_podman_socket_tests.sh
