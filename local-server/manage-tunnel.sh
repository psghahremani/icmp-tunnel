#!/usr/bin/bash

FOREIGN_SERVER_IP=<SET_THIS_FIELD>

startTunnel() {
  echo "Running the ICMP tunnel process..."
  /opt/icmp-tunnel/icmptunnel $FOREIGN_SERVER_IP &
  echo "Tunnel command status:"
  echo $!
  ip addr add 10.0.0.2/24 dev tun0
  ip link set up dev tun0
  ip route del default > /dev/null 2>&1
  ip route add default via 10.0.0.1
  echo "Device tun0 is now set up."
}
stopTunnel() {
  killall -SIGTERM icmptunnel > /dev/null 2>&1
  ip route del default > /dev/null 2>&1
  ip route add default via $(cat /opt/icmp-tunnel/local-gateway.txt)
}

MUST_TERMINATE=0
terminate() {
  MUST_TERMINATE=1
  echo -e "\nStopping the tunnel..."
  stopTunnel
  echo "The tunnel has been stopped."
  exit 0
}
trap terminate INT TERM

stopTunnel
startTunnel
while [ MUST_TERMINATE != 0 ]; do
  sleep 1
  echo "Checking internet connectivity..."
  curl -s -m 2 10.0.0.1:8080 > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    echo "Tunnel is up."
  else
    stopTunnel
    echo "Tunnel is down, attempting to start the tunnel after some time..."
    sleep 5
    startTunnel
    echo "Tunnel has been started."
  fi
done
