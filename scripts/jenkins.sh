#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

apt update -y
apt upgrade -y

################################
# BASIC PACKAGES
################################
apt install -y \
openjdk-21-jdk \
docker.io \
git \
curl \
wget \
unzip \
python3 \
python3-pip \
software-properties-common \
gnupg \
lsb-release

################################
# DOCKER
################################
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

################################
# JENKINS (Updated Repository & 2026 Key)
################################
mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://jenkins.io

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y fontconfig openjdk-21-jre jenkins

systemctl enable jenkins
systemctl start jenkins
usermod -aG docker jenkins

################################
# ANSIBLE
################################
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible

################################
# PYTHON BOTO3
################################
pip3 install boto3 --break-system-packages

################################
# AWS CLI V2
################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

################################
# KUBECTL
################################
curl -LO "https://dl.k8s.io/release/stable/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

################################
# HELM
################################
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

################################
# TERRAFORM
################################
wget https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip
unzip terraform_1.14.0_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_1.14.0_linux_amd64.zip

################################
# TRIVY
################################
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | tee /etc/apt/sources.list.d/trivy.list
apt update -y
apt install -y trivy

################################
# VERSIONS VERIFICATION
################################
java --version
docker --version
git --version
terraform version
ansible --version
kubectl version --client
helm version
trivy --version
aws --version
