################################
# JENKINS + ANSIBLE SERVER
################################

resource "aws_instance" "jenkins" {

  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.medium"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]

  iam_instance_profile = aws_iam_instance_profile.main.name

  user_data = file("scripts/jenkins.sh")

  tags = {
    Name = "jenkins-server"
  }
}

################################
# DEVSECOPS SERVER
################################

resource "aws_instance" "devsecops" {

  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.large"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]

  user_data = file("scripts/devsecops.sh")

  tags = {
    Name = "devsecops-server"
  }
}

################################
# MONITORING SERVER
################################

resource "aws_instance" "monitoring" {

  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.medium"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]

  user_data = file("scripts/monitoring.sh")

  tags = {
    Name = "monitoring-server"
  }
}

