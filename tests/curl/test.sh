#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "rel=\$(rpm -q \$(rpm -qf /etc/redhat-release) --queryformat '%{version}\n' | awk -F. '{print \$1}')"
if [ $rel -ge 9 ]; then
  rlRun "dnf install -y /usr/bin/curl"
else
  rlRun "yum install -y curl"
fi
  rlRun "./server.sh start"
  rlPhaseEnd

  rlPhaseStartTest "Verifying that can download"
  rlRun -s "curl --location -s http://localhost:8000/page/index.html"
  rlAssertGrep "DOWNLOAD_TEST" "$rlRun_LOG"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "./server.sh stop"
  rlPhaseEnd

rlJournalEnd
