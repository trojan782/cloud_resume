resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  read_capacity  = 15
  write_capacity = 15
  hash_key       = "id"


  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name        = "${var.table_name}-table"
    Environment = "production"
  }
}