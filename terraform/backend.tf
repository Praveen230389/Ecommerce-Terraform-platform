################################
# TERRAFORM BACKEND CONFIG
################################

terraform {
  backend "s3" {
    # FIXED: यहाँ अपने एडब्ल्यूएस पर बनाए गए असली बकेट का नाम डालें
    bucket         = "praveen-tfstate-bucket-unique-99" 
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    
    # FIXED: वॉर्निंग हटाने के लिए पुरानी dynamodb_table को आधुनिक use_lockfile से बदल दिया
    use_lockfile   = true
  }
}
