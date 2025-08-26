#!/bin/bash
set -e

echo "=== Removendo Tailscale (Docker) instalado via script ==="

CONTAINER_NAME="tailscale"
SERVICE_PATH="/etc/systemd/system/tailscale.service"
STATE_DIR="/var/lib/tailscale"

# Para e remove service
sudo systemctl stop tailscale || true
sudo systemctl disable tailscale || true
sudo rm -f ${SERVICE_PATH}

# Para e remove container se sobrar
docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

# Remove diretório de estado
sudo rm -rf ${STATE_DIR}

# Recarrega systemd
sudo systemctl daemon-reload

echo "=== Desinstalação concluída! ==="
