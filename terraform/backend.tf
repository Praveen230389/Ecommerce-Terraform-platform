################################
# TERRAFORM BACKEND CONFIG
################################

terraform {
  backend "s3" {
    bucket         = "ecommerce-terraform-state-bucket-12345"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

