terraform {
  backend "s3" {
    bucket         = "resumeapi2024"
    key            = "resume_api/prod/terraform.tfstate" 
    dynamodb_table = "terraform-state-locks"
    region         = "us-east-1"
    encrypt        = true
  }
}