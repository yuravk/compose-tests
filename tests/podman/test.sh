#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1


rlJournalStart
  rlPhaseStartSetup
  rlRun "dnf -y install podman"
if ! grep /etc/subuid -q -e "${USER}"; then
  rlRun "usermod --add-subuids 100000-165537 ${USER}"
fi
if ! grep /etc/subgid -q -e "${USER}"; then
  rlRun "usermod --add-subgids 100000-165537 ${USER}"
fi
  rlPhaseEnd
  
  rlPhaseStartTest "get version"
  rlRun "podman version"
  rlPhaseEnd

  rlPhaseStartTest "get info"
  rlRun "podman info"
  rlPhaseEnd

  rlPhaseStartTest "test pulling image"
  rlRun "podman image pull quay.io/fedora/fedora:latest"
  rlRun "podman image rm quay.io/fedora/fedora:latest"
  rlPhaseEnd

  rlPhaseStartTest "test listing image"
  rlRun "podman image pull quay.io/fedora/fedora:latest"
  rlRun -s "podman image ls quay.io/fedora/fedora:latest"
  rlAssertGrep "quay.io/fedora/fedora" $rlRun_LOG
  rlRun "podman image rm quay.io/fedora/fedora:latest"
  rlPhaseEnd

  rlPhaseStartTest "test container run"
  rlRun "podman run --rm quay.io/fedora/fedora:latest bash -c 'echo HELLO' | grep -q -e 'HELLO'"
  rlPhaseEnd

  rlPhaseStartTest "test system service"
  rlRun "podman system service -t 1"
  rlPhaseEnd

  rlPhaseStartTest "test mounting file"
  rlRun "touch test.txt"
  rlRun "podman run --rm --privileged -v $(pwd)/test.txt:/test.txt quay.io/fedora/fedora:latest bash -c 'echo HELLO > /test.txt'"
  rlRun "grep -q -e 'HELLO' test.txt"
  rlRun "rm -f test.txt"
  rlPhaseEnd

  rlPhaseStartTest "test building"
  rlRun "podman build -t test:latest -f ./Containerfile"
  rlRun "podman image rm localhost/test:latest"
  rlPhaseEnd

  rlPhaseStartTest "test remote socket"
  rlRun "useradd podman-remote-test"
if ! grep /etc/subuid -q -e "podman-remote-test"; then
  rlRun "usermod --add-subuids 100000-165537 podman-remote-test"
fi
if ! grep /etc/subgid -q -e "podman-remote-test"; then
  rlRun "usermod --add-subgids 100000-165537 podman-remote-test"
fi
  rlRun "loginctl enable-linger podman-remote-test"
  rlWaitForCmd "loginctl show-user podman-remote-test" -t 10
  rlRun "sudo -i -u podman-remote-test < ./remote-socket-test.sh"
  rlRun "loginctl terminate-user podman-remote-test"
  rlRun "loginctl disable-linger podman-remote-test"
  rlWaitForCmd "loginctl show-user podman-remote-test" -t 10 -r 1
  rlRun "userdel -r podman-remote-test"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "dnf remove -y podman"
  rlPhaseEnd

rlJournalEnd
