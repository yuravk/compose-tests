#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "yum install -y wget"
  rlRun "FILE=$(mktemp)"
  rlRun "rel=\$(rpm -q \$(rpm -qf /etc/redhat-release) --queryformat '%{version}\n' | awk -F. '{print \$1}')"
  rlRun "./server.sh start"
  rlPhaseEnd

  rlPhaseStartTest "Verifying that can download"
  rlRun "wget -q --output-document=${FILE} http://127.0.0.1:8000/page/index.html"
  rlAssertGrep "DOWNLOAD_TEST" "${FILE}"
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "./server.sh stop"
  rlRun "rm -f ${FILE}"
  rlPhaseEnd

rlJournalEnd
