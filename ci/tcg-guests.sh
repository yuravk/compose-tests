#!/bin/bash
# Boot guests of a foreign architecture under QEMU TCG (full-system emulation,
# no KVM) from an AlmaLinux GenericCloud image, one per name in $guests, each
# on a copy-on-write overlay of the image. The guests run in the background;
# their serial consoles go to <dir>/<guest>.console.log. Each one is reachable
# as 'ssh <guest>' (and scp), as the 'almalinux' user with passwordless sudo,
# through ~/.ssh/config. The guests take a while to boot: wait for SSH.
# <dir>/<guest>.start boots a guest that was shut down again, the same way.
#
#   guests='almalinux-0 almalinux-1' ci/tcg-guests.sh ppc64le base.qcow2 /var/tmp/guests

usage="usage: $0 ARCH BASE_IMAGE DIR"
arch=${1:?${usage}}
base=${2:?${usage}}
dir=${3:?${usage}}
set -e -o pipefail

case ${arch} in
  ppc64le)
    qemu=qemu-system-ppc64
    # POWER9 is the oldest CPU AlmaLinux 10 runs on. The cap-* are the
    # speculative-execution mitigations TCG cannot provide; set them off
    # explicitly so QEMU does not warn about each one. Without a VGA device
    # SLOF and the kernel use the spapr-vty serial console, which is logged.
    machine=(-machine pseries,cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off
             -cpu POWER9 -vga none)
    bus=pci
    ;;
  s390x)
    qemu=qemu-system-s390x
    # 'max' is the newest CPU TCG emulates (AlmaLinux 10 needs z15). The
    # serial console is the SCLP console, which is logged.
    machine=(-machine "s390-ccw-virtio" -cpu max)
    # Channel I/O instead of PCI
    bus=ccw
    ;;
  *)
    echo "[Error] Unsupported architecture: ${arch}" >&2
    exit 1
    ;;
esac

set -- ${guests:?}
count=$#
# Split the host between the guests like ci/Vagrant/Vagrantfile: leave 2 CPUs
# to the host and give the guests 75% of its RAM. Multi-threaded TCG runs a
# host thread per guest CPU. pseries needs the RAM in multiples of 256 MiB.
cpus=$(( ($(nproc) - 2) / count ))
[ "${cpus}" -ge 1 ] || cpus=1
ram=$(( $(awk '/^MemTotal:/ {print $2}' /proc/meminfo) / 1024 * 3 / 4 / count / 256 * 256 ))
[ "${ram}" -ge 1024 ] || ram=1024
echo "[Debug] ${count} ${arch} guests, ${cpus} CPUs and ${ram} MiB RAM each"

base=$(realpath "${base}")
mkdir -p "${dir}" ~/.ssh
chmod 700 ~/.ssh
dir=$(realpath "${dir}")
key=${dir}/id_ed25519
[ -f "${key}" ] || ssh-keygen -t ed25519 -N '' -q -C tcg-guests -f "${key}"

i=0
for guest in ${guests}; do
  port=$(( 2222 + i ))
  i=$(( i + 1 ))

  # Sparse: the overlay grows only by what the guest writes
  qemu-img create -q -f qcow2 -F qcow2 -b "${base}" "${dir}/${guest}.qcow2" 60G

  # cloud-init NoCloud seed
  printf 'instance-id: %s\nlocal-hostname: %s\n' "${guest}" "${guest}" > "${dir}/${guest}.meta-data"
  cat > "${dir}/${guest}.user-data" <<EOF
#cloud-config
users:
  - name: almalinux
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - $(cat "${key}.pub")
ssh_pwauth: false
EOF
  cloud-localds "${dir}/${guest}.seed.iso" "${dir}/${guest}.user-data" "${dir}/${guest}.meta-data"

  # The guests are throwaway: cache=unsafe skips the host flushes, which are
  # slow, of every guest fsync. The console log is appended to, so that it
  # keeps the earlier boots of a guest started again with <guest>.start.
  qemu_args=("${qemu}" -name "${guest}" "${machine[@]}"
    -accel tcg,thread=multi -smp "${cpus}" -m "${ram}"
    -drive "file=${dir}/${guest}.qcow2,if=none,id=disk,format=qcow2,cache=unsafe,discard=unmap"
    -device "virtio-blk-${bus},drive=disk,bootindex=0"
    -drive "file=${dir}/${guest}.seed.iso,if=none,id=seed,format=raw,readonly=on"
    -device "virtio-blk-${bus},drive=seed"
    -netdev "user,id=net,hostfwd=tcp:127.0.0.1:${port}-:22"
    -device "virtio-net-${bus},netdev=net"
    -display none
    -chardev "file,id=console,path=${dir}/${guest}.console.log,append=on"
    -serial chardev:console
    -pidfile "${dir}/${guest}.pid"
    -daemonize)
  { echo '#!/bin/bash'; printf 'exec'; printf ' %q' "${qemu_args[@]}"; echo; } > "${dir}/${guest}.start"
  chmod +x "${dir}/${guest}.start"
  "${dir}/${guest}.start"
  echo "[Debug] ${guest}: PID $(cat "${dir}/${guest}.pid"), SSH on 127.0.0.1:${port}"

  cat >> ~/.ssh/config <<EOF
Host ${guest}
  HostName 127.0.0.1
  Port ${port}
  User almalinux
  IdentityFile ${key}
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel ERROR
  ConnectTimeout 30
  # An emulated guest under load can stall for minutes: ~10 min before
  # giving up on the session
  ServerAliveInterval 30
  ServerAliveCountMax 20
EOF
done
