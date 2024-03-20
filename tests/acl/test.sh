#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "dnf install -y acl"
  rlRun "touch /tmp/acl_test_file"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "setfacl -m user:nobody:r-- /tmp/acl_test_file"
  rlRun -s "getfacl /tmp/acl_test_file"
  rlAssertGrep "user:nobody:r--" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "/bin/rm -f /tmp/acl_test_file"
  rlPhaseEnd

rlJournalEnd
