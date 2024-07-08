#!/bin/bash
# Author: Neal Gompa <ngompa@datto.com>

# Run the test
t_Log "Running $0 - build a hello world program with gcc-c++ using annobin"

BUILTPROG=$(mktemp)

cat <<EOF | g++ -x c++ -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -o ${BUILTPROG} -
#include <iostream>
int main() {
	std::cout << "Hello World!\n";
	return 0;
}
EOF

${BUILTPROG} | grep -q "Hello World"
t_CheckExitStatus $?

rm -f ${BUILTPROG}
