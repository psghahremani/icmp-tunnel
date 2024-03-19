#!/usr/bin/bash

startServer() {
  echo "Running the server with custom parameters..."
  /opt/icmp-tunnel/icmptunnel -s -k 0.5 -r 10 -e &
  sleep 1
  ip addr add 10.0.0.1/24 dev tun0
  ip link set up dev tun0
}
stopServer() {
  killall -SIGTERM icmptunnel > /dev/null 2>&1
}

MUST_TERMINATE=0
terminate() {
  MUST_TERMINATE=1
  echo -e "\nStopping the server..."
  stopServer
  echo "The server has been stopped."
  exit 0
}
trap terminate INT TERM

stopServer
while [ MUST_TERMINATE != 0 ]; do
  sleep 1
  if ip link show tun0 > /dev/null 2>&1; then
    echo "Server is up."
  else
    stopServer
    echo "Server is down, attempting to start the server..."
    startServer
    echo "Server has been started."
  fi
done
