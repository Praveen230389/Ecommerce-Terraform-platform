terraform {
required_version = ">= 1.14.8"
required_providers {
aws = {
source = "hashicorp/aws"
version = ">= 6.40.1"
}
}
}
################################
PROVIDER
################################
provider "aws" {
region = "ap-south-1"
}
################################
VPC
################################
resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"
tags = {
Name = "ecommerce-vpc"
}
}
################################
INTERNET GATEWAY
################################
resource "aws_internet_gateway" "main" {
vpc_id = aws_vpc.main.id
tags = {
Name = "ecommerce-igw"
}
}
################################
PUBLIC SUBNET 1
################################
resource "aws_subnet" "public1" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.1.0/24"
availability_zone = "ap-south-1a"
map_public_ip_on_launch = true
tags = {
Name = "public-subnet-1"
}
}
################################
PUBLIC SUBNET 2
################################
resource "aws_subnet" "public2" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.2.0/24"
availability_zone = "ap-south-1b"
map_public_ip_on_launch = true
tags = {
Name = "public-subnet-2"
}
}
################################
PRIVATE SUBNET 1
################################
resource "aws_subnet" "private1" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.3.0/24"
availability_zone = "ap-south-1a"
tags = {
Name = "private-subnet-1"
}
}
################################
PRIVATE SUBNET 2
################################
resource "aws_subnet" "private2" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.4.0/24"
availability_zone = "ap-south-1b"
tags = {
Name = "private-subnet-2"
}
}
################################
PUBLIC ROUTE TABLE
################################
resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.main.id
}
tags = {
Name = "public-route-table"
}
}
################################
ROUTE ASSOCIATIONS
################################
resource "aws_route_table_association" "public1" {
subnet_id = aws_subnet.public1.id
route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
subnet_id = aws_subnet.public2.id
route_table_id = aws_route_table.public.id
}
################################
SECURITY GROUP
################################
resource "aws_security_group" "main" {
name = "main-sg"
vpc_id = aws_vpc.main.id
ingress {
description = "SSH"
from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]

}
ingress {
description = "HTTP"
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]

}
ingress {
description = "HTTPS"
from_port   = 443
to_port     = 443
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]

}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
Name = "main-security-group"
}
}
################################
IAM ROLE
################################
resource "aws_iam_role" "ec2_role" {
name = "ec2-basic-role"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Effect = "Allow"
 Principal = {
    Service = "ec2.amazonaws.com"
  }

  Action = "sts:AssumeRole"
}]

})
}
################################
IAM INSTANCE PROFILE
################################
resource "aws_iam_instance_profile" "main" {
name = "ec2-profile"
role = aws_iam_role.ec2_role.name
}
################################
S3 BUCKET
################################
resource "aws_s3_bucket" "main" {
bucket = "praveen-ecommerce-bucket-12345"
tags = {
Name = "ecommerce-bucket"
}
}
################################
ECR REPOSITORY
################################
resource "aws_ecr_repository" "main" {
name = "ecommerce-repository"
image_scanning_configuration {
scan_on_push = true
}
tags = {
Name = "ecr-repository"
}
}
################################
CLOUDWATCH LOG GROUP
################################
resource "aws_cloudwatch_log_group" "main" {
name = "/ecommerce/application"
retention_in_days = 7
}
################################
SNS TOPIC
################################
resource "aws_sns_topic" "alerts" {
name = "ecommerce-alerts"
}
################################
ROUTE53 HOSTED ZONE
################################
resource "aws_route53_zone" "main" {
name = "praveenecom.com"
tags = {
Name = "main-zone"
}
}
################################
ACM CERTIFICATE
################################
resource "aws_acm_certificate" "main" {
domain_name = "praveenecom.com"
validation_method = "DNS"
tags = {
Name = "ssl-certificate"
}
}

