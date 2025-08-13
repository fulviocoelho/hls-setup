echo "#!/bin/bash" > /usr/local/bin/start-portainer.sh
echo "" >> /usr/local/bin/start-portainer.sh
echo CONTAINER_NAME="portainer" >> /usr/local/bin/start-portainer.sh
echo DOCKER_IMAGE="portainer/portainer-ce" >> /usr/local/bin/start-portainer.sh
echo "" >> /usr/local/bin/start-portainer.sh
echo 'if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then' >> /usr/local/bin/start-portainer.sh
echo '    docker rm -f "$CONTAINER_NAME"' >> /usr/local/bin/start-portainer.sh
echo 'fi' >> /usr/local/bin/start-portainer.sh
echo "" >> /usr/local/bin/start-portainer.sh
echo 'docker run -d --name "$CONTAINER_NAME" -v "/var/run/docker.sock:/var/run/docker.sock" -v /root/pods_data/portainer/data:/data -p 80:9000 "$DOCKER_IMAGE"' >> /usr/local/bin/start-portainer.sh

chmod +x /usr/local/bin/start-portainer.sh

echo '[Unit]' > /etc/systemd/system/portainer.service
echo 'Description=Serviço para subir container Docker "portainer"' >> /etc/systemd/system/portainer.service
echo '' >> /etc/systemd/system/portainer.service
echo '[Service]' >> /etc/systemd/system/portainer.service
echo 'Type=oneshot' >> /etc/systemd/system/portainer.service
echo 'ExecStart=/usr/local/bin/start-portainer.sh' >> /etc/systemd/system/portainer.service
echo 'ExecStop=/usr/bin/docker rm -f portainer' >> /etc/systemd/system/portainer.service
echo 'RemainAfterExit=yes' >> /etc/systemd/system/portainer.service
echo 'User=root' >> /etc/systemd/system/portainer.service
echo '' >> /etc/systemd/system/portainer.service
echo '[Install]' >> /etc/systemd/system/portainer.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/portainer.service

systemctl daemon-reload
systemctl enable portainer.service
systemctl start portainer.service
systemctl status portainer.service