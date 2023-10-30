#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup "pull image"
    rlRun "podman image pull quay.io/fedora/fedora:latest"
    rlPhaseEnd
     
    rlPhaseStartTest "Basic pull test"
    rlRun -s "podman image ls quay.io/fedora/fedora:latest"
    rlAssertGrep "quay.io/fedora/fedora" $rlRun_LOG
    rlPhaseEnd

    rlPhaseStartCleanup "remove image"
    rlRun "podman image rm quay.io/fedora/fedora:latest"
    rlPhaseEnd
rlJournalEnd
