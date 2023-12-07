#!/bin/bash -e

case $1 in
  start)
    python3 -m http.server > /dev/null 2>&1 &
    server_pid=$!
    echo "Starting with PID: $server_pid"
    echo "$server_pid" > server.pid
    ;;
  stop)
    kill -9 $(cat ./server.pid)
    rm -f ./server.pid
    ;;
  *)
    echo "unknown option"
    ;;
esac
