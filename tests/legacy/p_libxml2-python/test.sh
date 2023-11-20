#!/bin/bash -e

source ../functions.sh
./0-install-libxml2-python.sh
./1-test-XmlTextReader.sh
