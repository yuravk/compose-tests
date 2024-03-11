#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlServiceStart "libvirtd"
  rlPhaseEnd

  rlPhaseStartTest "should version"
  rlRun "virsh --version"
  rlPhaseEnd

  rlPhaseStartTest "should list one iface"
  rlRun -s "virsh -c qemu:///system iface-list"
  rlAssertGrep "active" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should list default net"
  rlRun -s "virsh -c qemu:///system net-list"
  rlAssertGrep 'default.*active' $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should find and list dhcp clients (empty) default network"
  rlRun "virsh -c qemu:///system net-dhcp-leases default"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlServiceStop "libvirtd"
  rlPhaseEnd

rlJournalEnd
