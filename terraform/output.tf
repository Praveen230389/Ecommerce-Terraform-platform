################################
# OUTPUTS
################################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "jenkins_server_ip" {
  value = aws_instance.jenkins.public_ip
}

output "devsecops_server_ip" {
  value = aws_instance.devsecops.public_ip
}

output "monitoring_server_ip" {
  value = aws_instance.monitoring.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

