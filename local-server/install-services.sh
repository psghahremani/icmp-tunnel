#!/usr/bin/bash

if [ ! -e "./add-routes.sh" ]; then
  echo "Could not find 'add-routes.sh' in the current directory."
  exit 1
fi

cp ./add-routes.sh /opt/icmp-tunnel
echo "[Service]
Type=oneshot
ExecStart=bash /opt/icmp-tunnel/add-routes.sh.sh

[Install]
WantedBy=default.target
" > /lib/systemd/system/add-routes.service

systemctl enable add-routes.service
systemctl start add-routes.service


if [ ! -e "./manage-tunnel.sh" ]; then
  echo "Could not find 'manage-tunnel.sh' in the current directory."
  exit 1
fi

cp ./manage-tunnel.sh /opt/icmp-tunnel
echo "[Service]
ExecStart=bash /opt/icmp-tunnel/manage-tunnel.sh
Restart=always

[Install]
WantedBy=default.target
" > /lib/systemd/system/icmp-tunnel.service

systemctl enable icmp-tunnel.service
systemctl start icmp-tunnel.service
