#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "yum install -y sysstat"
  rlRun 'TmpDir=$(mktemp -d)' 0 'Creating tmp directory' # no-reboot
  rlRun "pushd $TmpDir"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "/usr/lib64/sa/sa1 --boot"
  rlRun "sar -u | grep -q -e 'LINUX RESTART'"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "/usr/lib64/sa/sa1 1 1"
  rlRun "sleep 3" 0 "Allow time for metrics counting"
  rlRun "/usr/lib64/sa/sa1 1 1"
  rlRun "sar -u | grep -q -e 'Average'"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "/usr/lib64/sa/sa2 -A"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "popd"
  rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
  rlRun "yum remove -y sysstat"
  rlPhaseEnd

rlJournalEnd
