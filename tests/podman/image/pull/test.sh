#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartTest "Basic pull test"
    rlRun "podman image pull quay.io/fedora/fedora:latest"
    rlPhaseEnd
    rlPhaseStartCleanup "remove image"
    rlRun "podman image rm quay.io/fedora/fedora:latest"
    rlPhaseEnd
rlJournalEnd
