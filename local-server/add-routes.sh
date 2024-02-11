LOCAL_GATEWAY=$(ip route show default | awk '{print $3}')
echo $LOCAL_GATEWAY > /opt/icmp-tunnel/local-gateway.txt
FOREIGN_SERVER_IP=<SET_THIS_FIELD>
ip route add $FOREIGN_SERVER_IP via $LOCAL_GATEWAY metric 200
for range in $(cat /opt/icmp-tunnel/skipped-ip-ranges.txt); do
  ip route add $range via $LOCAL_GATEWAY
done
