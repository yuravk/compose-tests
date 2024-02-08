#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart

  rlPhaseStartSetup
  rlRun "yum install -y sysstat"
  rlRun 'TmpDir=$(mktemp -d)' 0 'Creating tmp directory' # no-reboot
  rlRun "pushd $TmpDir"

  rlRun 'n_cpu=$(nproc)'
  rlRun 'load=$((${n_cpu}/2))'
if [ "${load}" -eq 0 ]; then
  rlRun 'load=1'
fi
  rlPhaseEnd

  rlPhaseStartTest
  rlRun "/usr/bin/mpstat 1 10 > output &"
  rlRun "sleep 1" 0 "Time for iostat booting"
for i in $(seq 1 ${load}); do 
  rlRun "sha1sum /dev/zero &" 0 "Give the CPU something to chew on"
done
  rlRun "sleep 10" 0 "Give mpstat a chance to log our task"
  rlRun "killall sha1sum" 0 "Stop CPU load"
  rlRun "cat output" 0 "Display captured output"
  rlRun "cpu_user_percent=\$(awk '\$4 ~ /[0-9]\./ {\$4>a ? a=\$4 : \$4} END {print int(a)}' output)" 0 "Extract cpu utilization"
  rlAssertNotEquals "Should register CPU utilization" $cpu_user_percent 0
  rlPhaseEnd

  rlPhaseStartCleanup
  rlRun "popd"
  rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
  rlRun "yum remove -y sysstat"
  rlPhaseEnd

rlJournalEnd
