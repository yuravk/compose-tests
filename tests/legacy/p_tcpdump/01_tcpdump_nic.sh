#!/bin/sh
# Author: Christoph Galuschka <tigalch@tigalch.org>
#         Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - TCPdump test to Default-GW with IPv4"

# Grabing Default-Router if NIC
def_gw=$(ip route list default|grep "default via"|head -n 1|awk '{print $3}')
eth_int=$(ip addr|grep -B 1 "link/ether"|head -n 1|awk '{print $2}'|tr -d ':')

  t_Log "Found Default-GW - starting tcpdump test"
  #Dumping 4 pings via NIC to file
  FILE='/var/tmp/nic_test.pcap'
  COUNT='4'
  tcpdump -i $eth_int -q -n -p -w $FILE &
  # If we don't wait a short time, the first paket will be missed by tcpdump
  sleep 1
  ping -q -c $COUNT -i 0.25 ${def_gw} > /dev/null 2>&1
  sleep 1
  killall -s SIGINT tcpdump
  sleep 1
  # reading from file, for each ping we should see two pakets
  WORKING=$( tcpdump -r $FILE | grep -ci icmp )
  if [ $WORKING != $[COUNT*2] ]
    then
    t_Log "ping to Default-Gateway did not return the number of pakets we expect. "$WORKING" of "$[COUNT*2]" pakets were dumped to file"
    ret_val=1
  else
    t_Log "ping to Default-Gateway looks OK. "$WORKING" of "$[COUNT*2]" pakets were dumped to file"
    ret_val=0
  fi
# Remove file afterwards
/bin/rm $FILE

t_CheckExitStatus $ret_val
