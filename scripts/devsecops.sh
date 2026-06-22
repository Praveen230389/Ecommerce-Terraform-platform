#!/bin/bash
set -e

apt update -y
apt upgrade -y
apt install -y docker.io curl git

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

################################
# SONARQUBE HOST CONFIG (Mandatory for ES)
################################
sysctl -w vm.max_map_count=524288
echo "vm.max_map_count=524288" >> /etc/sysctl.conf

################################
# SONARQUBE RUN
################################
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

docker run -d \
--name sonarqube \
-p 9000:9000 \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_logs:/opt/sonarqube/logs \
-v sonarqube_extensions:/opt/sonarqube/extensions \
--restart unless-stopped \
sonarqube:lts-community

################################
# NEXUS
################################
docker volume create nexus-data

docker run -d \
--name nexus \
-p 8081:8081 \
-v nexus-data:/nexus-data \
--restart unless-stopped \
sonatype/nexus3


