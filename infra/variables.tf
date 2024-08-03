variable "name" {
  type    = string
  default = "resume-api"
}

variable "table_name" {
  type    = string
  default = "resume-table"
}

variable "remote_state_bucket" {
  type = string
  description = "s3 bucket for the remote state file"
}