################################
# JENKINS + ANSIBLE SERVER
################################
resource "aws_instance" "jenkins" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public1.id

  # Updated to use the secure isolated Jenkins Security Group
  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.main.name
  user_data            = file("scripts/jenkins.sh")

  tags = {
    Name = "jenkins-server"
  }
}

################################
# DEVSECOPS SERVER (SonarQube & Nexus)
################################
resource "aws_instance" "devsecops" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.large"
  subnet_id     = aws_subnet.public1.id

  # Updated to use the secure DevSecOps Security Group
  vpc_security_group_ids = [
    aws_security_group.devsecops_sg.id
  ]

  user_data = file("scripts/devsecops.sh")

  tags = {
    Name = "devsecops-server"
  }
}

################################
# MONITORING SERVER (Prometheus & Grafana)
################################
resource "aws_instance" "monitoring" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public1.id

  # Updated to use the isolated Monitoring Security Group
  vpc_security_group_ids = [
    aws_security_group.monitoring_sg.id
  ]

  user_data = file("scripts/monitoring.sh")

  tags = {
    Name = "monitoring-server"
  }
}
