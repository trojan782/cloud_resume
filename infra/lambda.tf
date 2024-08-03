module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.name}-function"
  description   = "Lambda function to read json stored in dynamodb"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.12"

  source_path = "../src/"


  attach_policies          = true
  policies                 = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  attach_policy_statements = true

  environment_variables = {
    TABLE_NAME = "${var.table_name}"
  }
  policy_statements = {
    dynamodb_read = {
      effect    = "Allow",
      actions   = ["dynamodb:GetItem"],
      resources = ["${aws_dynamodb_table.this.arn}"]
    }
  }
  tags = {
    Name = "${var.name}"
  }
}