#!/bin/bash
set -e

echo "=== Instalação do Tailscale (Docker) via systemd ==="

read -p "Informe a Auth Key do Tailscale: " AUTH_KEY
read -p "Informe a rota a ser propagada (ex: 192.168.0.0/24): " ROTA
read -p "Informe o nome do Exit Node (ex: casa, servidor, homelab): " NODE_NAME

CONTAINER_NAME="tailscale"
HOSTNAME="exit-node-${NODE_NAME}"
IMAGE="tailscale/tailscale:stable"
STATE_DIR="/var/lib/tailscale"
SERVICE_PATH="/etc/systemd/system/tailscale.service"

# Cria diretório de estado
sudo mkdir -p ${STATE_DIR}

# Cria unit systemd que sempre recria o container
sudo tee ${SERVICE_PATH} > /dev/null <<EOF
[Unit]
Description=Tailscale (Docker)
After=docker.service network-online.target
Wants=network-online.target
Requires=docker.service

[Service]
Restart=always
RestartSec=5s
ExecStartPre=-/usr/bin/docker rm -f ${CONTAINER_NAME}
ExecStart=/usr/bin/docker run --rm \\
  --name ${CONTAINER_NAME} \\
  --hostname ${HOSTNAME} \\
  --network host \\
  --privileged \\
  -e TS_AUTHKEY=${AUTH_KEY} \\
  -e TS_STATE_DIR=/var/lib/tailscale \\
  -e TS_EXTRA_ARGS="--advertise-exit-node --advertise-routes=${ROTA}" \\
  -v ${STATE_DIR}:/var/lib/tailscale \\
  -v /dev/net/tun:/dev/net/tun \\
  ${IMAGE}
ExecStop=/usr/bin/docker stop ${CONTAINER_NAME}
Environment="PATH=/usr/local/bin:/usr/bin:/bin"

[Install]
WantedBy=multi-user.target
EOF

# Recarrega systemd
sudo systemctl daemon-reload
sudo systemctl enable tailscale
sudo systemctl start tailscale

echo "=== Instalação concluída! ==="
echo "Service criado: systemctl status tailscale"
