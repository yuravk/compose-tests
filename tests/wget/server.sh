#!/bin/bash -e

case $1 in
  start)
    python3 -m http.server --bind localhost &
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
