#!/usr/bin/bash

FOREIGN_SERVER_IP=<SET_THIS_FIELD>

startTunnel() {
  /opt/icmp-tunnel/icmptunnel $FOREIGN_SERVER_IP -r 20 -k 3 > /dev/null 2>&1 &
  sleep 1
  ip addr add 10.0.0.2/24 dev tun0
  ip link set up dev tun0
  ip route del default > /dev/null 2>&1
  ip route add default via 10.0.0.1
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
while [ MUST_TERMINATE != 0 ]; do
  sleep 1
  CURRENT_IP=$(curl -s -m 2 ifconfig.io)
  if [[ $? == 0 && $CURRENT_IP == $FOREIGN_SERVER_IP ]]; then
    echo "Tunnel is up."
  else
    stopTunnel
    echo "Tunnel is down, attempting to start the tunnel..."
    startTunnel
    echo "Tunnel has been started."
  fi
done
