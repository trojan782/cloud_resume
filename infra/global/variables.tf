variable "bucket_name" {
  description = "unique name for my state bucket"
  type = string
  default = "resumeapi2024"
}

variable "table_name" {
  description = "dynamodb for state lock"
  type = string
  default = "terraform-state-locks"
}

variable "remote_state_bucket" {
  description = "s3 bucket for the remote state"
  type = string
}