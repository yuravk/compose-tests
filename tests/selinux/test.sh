#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "rel=\$(rpm -q \$(rpm -qf /etc/redhat-release) --queryformat '%{version}\n' | awk -F. '{print \$1}')"
if [ $rel -ge 8 ]; then
  rlRun "dnf install -y python3-libselinux"
  rlRun "PYTHON=python3"
else
  rlRun "yum install -y libselinux-python"
  rlRun "PYTHON=python"
fi
  rlPhaseEnd

  rlPhaseStartTest "Verify there are no SELinux alerts"
  rlRun "grep -q -v 'AVC' /var/log/audit/audit.log"
  rlPhaseEnd

  rlPhaseStartTest "Verify is enforcing"
  rlRun "grep -q /sys/fs/selinux/enforce -e '1'"
  rlPhaseEnd

  rlPhaseStartTest "Test for policy mismatch"
  rlRun "$PYTHON ./mismatch.py"
  rlPhaseEnd

rlJournalEnd
