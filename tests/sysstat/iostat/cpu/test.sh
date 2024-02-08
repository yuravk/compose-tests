#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "yum install -y sysstat"
  rlRun 'TmpDir=$(mktemp -d)' 0 'Creating tmp directory' # no-reboot
  rlRun "pushd $TmpDir"

  rlRun "echo 1 > /proc/sys/vm/drop_caches" 0 "Clear out the pagecache to get an accurate reading"
  rlRun "drive=\$(fdisk -l|grep -Po -m1 '^/dev/[\D]+')" 0 "Capture a storage device name"
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "/usr/bin/iostat -c 1 10 > output 2>&1 &" 0 "Running iostat in the background"
  rlRun "sleep 1" 0 "Time for iostat booting"
  rlRun "/bin/dd if=$drive bs=4k count=25000 2>/dev/null|sha1sum -b - &>/dev/null" 0 "Give the CPU something to chew on"
  rlRun "sleep 10" 0 "Give iostat a chance to log our task"
  rlRun "cat output" 0 "Display captured output"
  rlRun "cpu_user_percent=\$(awk '\$1 ~ /[0-9]/ {\$1>a ? a=\$1 : \$1} END {print int(a)}' output)" 0 "Extract the CPU utilisation (user field, percentage)"
  rlAssertNotEquals "Should register CPU utilization" $cpu_user_percent 0
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "popd"
  rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
  rlRun "yum remove -y sysstat"
  rlPhaseEnd

rlJournalEnd
