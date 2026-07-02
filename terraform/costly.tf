################################
ELASTIC IP FOR NAT
################################
resource "aws_eip" "nat" {
domain = "vpc"
tags = {
Name = "nat-eip"
}
}
################################
NAT GATEWAY
################################
resource "aws_nat_gateway" "main" {
allocation_id = aws_eip.nat.id
subnet_id = aws_subnet.public1.id
tags = {
Name = "nat-gateway"
}
}
################################
PRIVATE ROUTE TABLE
################################
resource "aws_route_table" "private" {
vpc_id = aws_vpc.main.id
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.main.id
}
tags = {
Name = "private-route-table"
}
}
################################
EKS IAM ROLE
################################
resource "aws_iam_role" "eks_role" {
name = "eks-cluster-role"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
  Effect = "Allow"

  Principal = {
    Service = "eks.amazonaws.com"
  }

  Action = "sts:AssumeRole"
}]

})
}
################################
EKS CLUSTER
################################
resource "aws_eks_cluster" "main" {
name = "ecommerce-cluster"
role_arn = aws_iam_role.eks_role.arn
vpc_config {
subnet_ids = [
aws_subnet.public1.id,
aws_subnet.public2.id
]
}
depends_on = [
aws_iam_role.eks_role
]
}
################################
EKS NODE ROLE
################################
resource "aws_iam_role" "node_role" {
name = "eks-node-role"
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
EKS NODE GROUP
################################
resource "aws_eks_node_group" "main" {
cluster_name = aws_eks_cluster.main.name
node_group_name = "worker-nodes"
node_role_arn = aws_iam_role.node_role.arn
subnet_ids = [
aws_subnet.private1.id,
aws_subnet.private2.id
]
scaling_config {
desired_size = 2
min_size = 1
max_size = 3
}
instance_types = ["t3.medium"]
tags = {
Name = "eks-node-group"
}
}
################################
APPLICATION LOAD BALANCER
################################
################################
# APPLICATION LOAD BALANCER
################################
resource "aws_lb" "main" {
  name               = "ecommerce-alb"
  internal           = false
  load_balancer_type = "application"
  
  # 100% सही और प्रोडक्शन-ग्रेड सुरक्षा समूह से लिंक कर दिया
  security_groups = [
    aws_security_group.alb_sg.id
  ]
  
  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
  tags = {
    Name = "application-load-balancer"
  }
}
################################
DB SUBNET GROUP
################################
resource "aws_db_subnet_group" "main" {
name = "rds-subnet-group"
subnet_ids = [
aws_subnet.private1.id,
aws_subnet.private2.id
]
tags = {
Name = "rds-subnet-group"
}
}
################################
RDS MYSQL
################################
resource "aws_db_instance" "main" {
identifier = "ecommerce-db"
allocated_storage = 20
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
username = "admin"
password = "Password123@"
db_subnet_group_name = aws_db_subnet_group.main.name
skip_final_snapshot = true
tags = {
Name = "ecommerce-rds"
}
}
################################
REDIS SUBNET GROUP
################################
resource "aws_elasticache_subnet_group" "main" {
name = "redis-subnet-group"
subnet_ids = [
aws_subnet.private1.id,
aws_subnet.private2.id
]
}
################################
REDIS CLUSTER
################################
resource "aws_elasticache_cluster" "main" {
cluster_id = "redis-cluster"
engine = "redis"
node_type = "cache.t3.micro"
num_cache_nodes = 1
subnet_group_name = aws_elasticache_subnet_group.main.name
tags = {
Name = "redis-cluster"
}
}

