#!/bin/bash
# Run a shell command for every guest in $guests at once and wait for all.
# The command sees the guest name as $guest; its output lines are prefixed
# with '[<guest>] '. Exits non-zero if the command failed for any guest.
#
#   guests='almalinux-0 almalinux-1' ci/each-guest.sh 'ssh $guest uname -r'

cmd=${1:?usage: $0 COMMAND}
pids=()
for guest in ${guests:?}; do
  (
    set -o pipefail
    guest=${guest} bash -c "${cmd}" < /dev/null 2>&1 | sed -u "s/^/[${guest}] /"
  ) &
  pids+=($!)
done

rc=0
i=0
for guest in ${guests}; do
  if ! wait "${pids[${i}]}"; then
    echo "[Debug] Failed on ${guest}"
    rc=1
  fi
  i=$((i + 1))
done
exit ${rc}
