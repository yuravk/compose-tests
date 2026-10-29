#!/bin/bash
# Start AlmaLinux containers of a foreign architecture with podman, one per
# name in $guests, systemd as PID 1, run by QEMU user-mode emulation (the
# qemu-<arch> binfmt_misc handler must be registered). Waits until systemd has
# booted every container. Run commands in one with 'podman exec <guest> ...';
# remove them with 'podman rm -f -t 0 <guest>': they do not stop on systemd's
# stop signal under emulation.
#
#   guests='almalinux-0 almalinux-1' ci/container-guests.sh ppc64le docker.io/almalinux/9-init:latest
#
# Extra 'podman run' options can be given in $podman_run_options.

usage="usage: $0 ARCH IMAGE"
arch=${1:?${usage}}
image=${2:?${usage}}
set -e -o pipefail

if [ ! -e "/proc/sys/fs/binfmt_misc/qemu-${arch}" ]; then
  echo "[Error] No qemu-${arch} binfmt_misc handler: ${arch} binaries cannot run here" >&2
  exit 1
fi

podman pull -q --platform "linux/${arch}" "${image}" > /dev/null

for guest in ${guests:?}; do
  podman run -d --name "${guest}" --hostname "${guest}" --platform "linux/${arch}" \
    --systemd=always ${podman_run_options:-} "${image}" > /dev/null
done

for guest in ${guests}; do
  for i in $(seq 1 60); do
    state=$(podman exec "${guest}" systemctl is-system-running 2> /dev/null) || true
    case "${state}" in running|degraded) break ;; esac
    if [ "${i}" -eq 60 ]; then
      echo "[Error] ${guest}: systemd not up after 10 minutes ('${state}')" >&2
      exit 1
    fi
    sleep 10
  done

  # Under emulation the units with credentials (ImportCredential=) fail at
  # boot with 243/CREDENTIALS: QEMU does not translate the mount calls systemd
  # sets them up with. Run the two the system needs ourselves.
  podman exec "${guest}" sh -c 'systemd-sysusers; systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev; systemctl reset-failed' || true

  echo "[Debug] ${guest}: $(podman exec "${guest}" sh -c 'echo "$(uname -m), $(cat /etc/almalinux-release), systemd $(systemctl is-system-running)"')"
  podman exec "${guest}" systemctl --failed --no-legend --plain
done
