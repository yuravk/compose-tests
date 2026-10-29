#!/bin/bash
# Restart a guest started by ci/tcg-guests.sh, e.g. to boot a newly installed
# kernel: power it off and, once its QEMU has exited, start it again with
# <dir>/<guest>.start. Succeeds when the guest answers SSH with another boot
# ID, so that a guest still shutting down does not pass for a restarted one.
#
# Not a reboot inside the guest: under TCG an s390x kernel ends that in a
# disabled wait, which QEMU takes for a panic (it powers the guest off), and
# GRUB of a ppc64le guest has hung after one. A guest that does not answer in
# $boot_wait seconds (default 900) is killed and started again, once.
#
#   ci/tcg-guest-restart.sh almalinux-0 /var/tmp/guests

usage="usage: $0 GUEST DIR"
guest=${1:?${usage}}
dir=${2:?${usage}}
boot_wait=${boot_wait:-900}
set -e -o pipefail

# Wait up to $2 seconds for process $1 to exit
wait_exit() {
  for _ in $(seq 1 $(( $2 / 5 ))); do
    kill -0 "$1" 2> /dev/null || return 0
    sleep 5
  done
  return 1
}

kill_qemu() {
  kill "$1" 2> /dev/null || true
  wait_exit "$1" 30 || { kill -9 "$1" 2> /dev/null || true; wait_exit "$1" 30; }
}

boot_id=$(ssh "${guest}" cat /proc/sys/kernel/random/boot_id)
qemu_pid=$(cat "${dir}/${guest}.pid")
echo "[Debug] ${guest}: powering off to restart"
ssh "${guest}" "sudo poweroff" || true
if ! wait_exit "${qemu_pid}" 1200; then
  echo "[Debug] ${guest}: still running 20 minutes after the poweroff, killing QEMU"
  kill_qemu "${qemu_pid}"
fi

for attempt in 1 2; do
  "${dir}/${guest}.start"
  qemu_pid=$(cat "${dir}/${guest}.pid")
  for i in $(seq 1 $(( boot_wait / 10 ))); do
    sleep 10
    new_boot_id=$(ssh -o ConnectionAttempts=1 "${guest}" cat /proc/sys/kernel/random/boot_id 2> /dev/null) || new_boot_id=
    if [ -n "${new_boot_id}" ] && [ "${new_boot_id}" != "${boot_id}" ]; then
      echo "[Debug] ${guest}: back after $(( i * 10 ))s, running $(ssh "${guest}" uname -r)"
      exit 0
    fi
  done
  echo "[Debug] ${guest}: no SSH ${boot_wait}s after start ${attempt}, killing QEMU"
  kill_qemu "${qemu_pid}"
done
echo "[Error] ${guest}: did not come back after 2 starts" >&2
exit 1
