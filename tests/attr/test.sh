#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "dnf install -y attr"
  rlRun "dd if=/dev/zero of=/tmp/attrtest.img bs=1024000 count=100"
  rlRun "echo -e 'y\n' | mkfs.ext3 /tmp/attrtest.img"
  rlRun "mkdir -p /mnt/attr_test"
  rlRun "mount -t ext3 -o loop,user_xattr /tmp/attrtest.img /mnt/attr_test"
  rlRun "touch /mnt/attr_test/testfile"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "setfattr -n user.test /mnt/attr_test/testfile"
  rlRun -s "getfattr /mnt/attr_test/testfile"
  rlAssertGrep "user.test" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "umount /mnt/attr_test"
  rlRun "rm -f /tmp/attrtest.img"
  rlPhaseEnd

rlJournalEnd
