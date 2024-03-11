#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "yum install -y perf"
  rlRun 'TmpDir=$(mktemp -d)' 0 'Creating tmp directory' # no-reboot
  rlRun "pushd $TmpDir"
  rlPhaseEnd

  rlPhaseStartTest "get version"
  rlRun "perf version"
  rlPhaseEnd

  rlPhaseStartTest "test recording"
  rlRun "perf record -F 49 -a -g -- sleep 1 > /dev/null 2>&1"
  rlRun "perf report --stats"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "popd"
  rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
  rlRun "yum remove -y perf"
  rlPhaseEnd

rlJournalEnd
