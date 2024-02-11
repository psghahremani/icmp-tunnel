#!/usr/bin/bash

if [ ! -e "./manage-server.sh" ]; then
  echo "Could not find 'manage-service.sh' in the current directory."
  exit 1
fi

cp ./manage-server.sh /opt/icmp-tunnel
echo "[Service]
ExecStart=bash /opt/icmp-tunnel/manage-server.sh
Restart=always

[Install]
WantedBy=default.target
" > /lib/systemd/system/icmp-server.service

systemctl enable icmp-server.service
systemctl start icmp-server.service
