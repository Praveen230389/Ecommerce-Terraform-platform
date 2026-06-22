#!/bin/bash
set -e

apt update -y
apt upgrade -y
apt install -y docker.io curl

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

################################
# PROMETHEUS
################################
docker volume create prometheus-data

docker run -d \
--name prometheus \
-p 9090:9090 \
-v prometheus-data:/prometheus \
--restart unless-stopped \
prom/prometheus

################################
# GRAFANA
################################
docker volume create grafana-data

docker run -d \
--name grafana \
-p 3000:3000 \
-v grafana-data:/var/lib/grafana \
--restart unless-stopped \
grafana/grafana
