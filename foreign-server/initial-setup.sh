#!/usr/bin/bash

apt install -y make gcc
git clone https://github.com/jamesbarlow/icmptunnel /opt/icmp-tunnel
make -C /opt/icmp-tunnel

echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

iptables -t filter -F
iptables -t nat -F

DEFAULT_INTERFACE=$(ip route show default | awk '{print $5}')
iptables -t nat -C POSTROUTING -o $DEFAULT_INTERFACE -j MASQUERADE || iptables -t nat -A POSTROUTING -o $DEFAULT_INTERFACE -j MASQUERADE

mkdir /etc/iptables
iptables-save > /etc/iptables/rules.v4

DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
systemctl enable netfilter-persistent.service

# Reboot, then verify the following:
# sysctl -a | grep "net.ipv4.ip_forward = 1"
# sysctl -a | grep "net.ipv4.icmp_echo_ignore_all = 1"
# iptables -t nat -S
