#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "dnf install -y freeradius freeradius-utils"
  rlRun "pushd /etc/raddb/certs/"
  rlRun "make"
  rlRun "chown root:radiusd *"
  rlRun "popd"
  rlRun "cp -f ./authorize /etc/raddb/mods-config/files/authorize"
  rlRun "chown root:radiusd /etc/raddb/mods-config/files/authorize"
  rlServiceStop radiusd
  rlServiceStart radiusd
  rlPhaseEnd

  rlPhaseStartTest "Verifying successful authentication"
  rlRun -s 'echo "User-Name=user,User-Password=password" | radclient -x localhost:1812 auth testing123' 0 'auth with valid creds'
  rlAssertNotGrep "Access-Reject" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "Verifying failed authentication"
  rlRun -s 'echo "User-Name=user2,User-Password=password2" | radclient -x localhost:1812 auth testing123' 1 'auth with bad creds'
  rlAssertGrep "Access-Reject" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartCleanup
  rlServiceStop radiusd
  rlRun "dnf remove -y freeradius freeradius-utils"
  rlPhaseEnd

rlJournalEnd
