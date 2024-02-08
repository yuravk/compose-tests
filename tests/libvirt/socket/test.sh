#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlServiceStart "libvirtd"
  rlPhaseEnd

  rlPhaseStartTest "should get version"
  rlRun "virsh --version"
  rlPhaseEnd

  rlPhaseStartTest "should list domains (empty) on test socket"
  rlRun "virsh -c test:///default list"
  rlPhaseEnd

  rlPhaseStartTest "should list domains (empty) on qemu socket"
  rlRun "virsh -c qemu:///system list"
  rlPhaseEnd

  rlPhaseStartTest "should get nodeinfo on qemu"
  rlRun "virsh -c qemu:///system nodeinfo"
  rlPhaseEnd

  rlPhaseStartTest "should get sysinfo on qemu"
  rlRun "virsh -c qemu:///system sysinfo"
  rlPhaseEnd

  rlPhaseStartTest "should access test socket with python"
  rlRun -s "python3 ./pytestaccess.py"
  rlAssertGrep "TEST" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should access qemu socket with python"
  rlRun -s "python3 ./pyqemuaccess.py"
  rlAssertGrep "QEMU" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartCleanup
  rlServiceStop "libvirtd"
  rlPhaseEnd

rlJournalEnd
