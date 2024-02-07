#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart



  rlPhaseStartTest "should not list test pool"
  rlRun -s "virsh -c qemu:///system pool-list --all"
  rlAssertNotGrep "libvirt-pool-test" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should create test pool"
  rlRun -s "virsh -c qemu:///system pool-define-as libvirt-pool-test dir - - - - /libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test defined" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should list new test pool"
  rlRun -s "virsh -c qemu:///system pool-list --all"
  rlAssertGrep "libvirt-pool-test.*inactive" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should build test pool"
  rlRun -s "virsh -c qemu:///system pool-build libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test built" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should start test pool"
  rlRun -s "virsh -c qemu:///system pool-start libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test started" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should list started pool"
  rlRun -s "virsh -c qemu:///system pool-list --all"
  rlAssertGrep "libvirt-pool-test.*active" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should show info of started pool"
  rlRun -s "virsh -c qemu:///system pool-info libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test" $rlRun_LOG
  rlAssertGrep "running" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should not list test volume on test pool"
  rlRun -s "virsh -c qemu:///system vol-list libvirt-pool-test"
  rlAssertNotGrep "volume1" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should create test volume on test pool"
  rlRun -s "virsh -c qemu:///system vol-create-as libvirt-pool-test volume1 1G"
  rlAssertGrep "volume1 created" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should list test volume"
  rlRun -s "virsh -c qemu:///system vol-list libvirt-pool-test"
  rlAssertGrep "volume1" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should show info of test volume"
  rlRun -s "virsh -c qemu:///system vol-info --pool libvirt-pool-test volume1"
  rlAssertGrep "volume1" $rlRun_LOG
  rlAssertGrep "Capacity:.*1\.00 GiB" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should delete test volume"
  rlRun -s "virsh -c qemu:///system vol-delete --pool libvirt-pool-test volume1"
  rlAssertGrep "volume1 deleted" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should not find test volume"
  rlRun -s "virsh -c qemu:///system vol-list libvirt-pool-test"
  rlAssertNotGrep "volume1" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should destroy test pool"
  rlRun -s "virsh -c qemu:///system pool-destroy libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test destroyed" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should delete test pool"
  rlRun -s "virsh -c qemu:///system pool-delete libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test deleted" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "should undefine test pool"
  rlRun -s "virsh -c qemu:///system pool-undefine libvirt-pool-test"
  rlAssertGrep "libvirt-pool-test has been undefined" $rlRun_LOG
  rlPhaseEnd
rlJournalEnd
