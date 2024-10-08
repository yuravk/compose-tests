#!/bin/sh
# Author: Christoph Galuschka <christoph.galuschka@chello.at>

if [ "$CONTAINERTEST" -eq "1" ]; then
    t_Log "Running in container -> SKIP"
    exit 0
fi

TEST=mtr

HOST="www.centos.org"

t_Log "Running $0 - running ${TEST} to ${HOST}"
ret_val=1
FILE=/var/tmp/mtr_result

IP=$(dig +short ${HOST} A ${HOST} AAAA)

# getting IP-address of default gateway as a fall back
defgw=$(ip route list | grep default | cut -d' ' -f3)

if [[ ! -z "$IP" ]]
then
  mtr -nr -c1 ${HOST} > ${FILE}
  COUNT=$(echo "$IP" | grep -cf - ${FILE})
  GW=$(grep -c ${defgw} ${FILE})
  if [ $COUNT = 1 ]
  then
    t_Log "${TEST} reached ${HOST}"
    ret_val=0
  elif ([ $COUNT = 0 ] && [ $GW -gt 0 ])
  then
    t_Log "${TEST} didn't reach ${HOST} (maybe because of ACLs on the network), but at least the Default Gateway ${defgw} was reached. Treating as SUCCESS."
    ret_val=0
  else
    t_Log "${TEST} didn't reach ${HOST}"
    ret_val=1
  fi
fi

/bin/rm ${FILE}
t_CheckExitStatus $ret_val
