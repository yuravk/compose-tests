#!/bin/bash -e

source ../functions.sh
./00_file_package.sh
./01_file_mime_application.sh
./02_file_mime_image.sh
./03_file_mime_symlink.sh
