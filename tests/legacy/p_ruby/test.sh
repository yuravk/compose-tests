#!/bin/bash -e

source ../functions.sh
./0-install-ruby.sh
./10-ruby-installed-test.sh
./20-ruby-version-test.sh
./25_ruby_hello-world.sh
./30-irb-version-test.sh
./40-ri-version-test.sh
./50-rdoc-version-test.sh
