#!/bin/bash -e

for test in *; do
  if [ -f $test ]; then
    continue
  fi

  test_sh=$(mktemp)
  chmod +x $test_sh

cat > $test_sh <<EOF
#!/bin/bash -e

source ../functions.sh
EOF

cat > $test/main.fmf <<EOF
summary: imported $test test set
description: $test imported as-is
test: ./test.sh
EOF

  for script in $test/*; do
    if [ -d "$script" ]; then
      continue
    fi
    if [ ! -x "$script" ]; then
      continue
    fi
    file_name=$(basename $script)
    if [ "${file_name:0:1}" == "_" ]; then
      continue
    fi
    echo "./$file_name" >> $test_sh
  done
  
  mv $test_sh $test/test.sh
done
