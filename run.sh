#!/bin/bash

#Init
apt update
apt upgrade -y
apt install certbot curl socat git net-tools -y
curl -fsSL https://get.docker.com | sh

#Marzban-Node
git clone https://github.com/Gozargah/Marzban-node
mkdir /var/lib/marzban-node
cd ~/Marzban-node || exit

#Block Iran domains/IPs
mkdir -p /var/lib/marzban/assets/
wget -O /var/lib/marzban/assets/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O /var/lib/marzban/assets/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
wget -O /var/lib/marzban/assets/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/iran.dat

#Docker compose
cat << EOF > docker-compose.yml
services:
  marzban-node:
    # build: .
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
      - /var/lib/marzban/assets:/usr/local/share/xray
EOF

#Certificate
nano /var/lib/marzban-node/ssl_client_cert.pem

docker compose up -d
