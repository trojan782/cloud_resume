# root resource of the api gateway
resource "aws_api_gateway_rest_api" "this" {
  name = "${var.name}-api-gw"
}

# defines endpoints under the root API
resource "aws_api_gateway_resource" "this" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "resume"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

# HTTP methods(GET, POST) for the endpoints
resource "aws_api_gateway_method" "this" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

# linking API gateway methods to the lambda function
resource "aws_api_gateway_integration" "this" {
  http_method = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  type        = "AWS_PROXY"
  uri         = module.lambda_function.lambda_function_invoke_arn
}

# Deployment resource for the API gatweay, required to deploy the api 
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  depends_on  = [aws_api_gateway_integration.this]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this.id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_integration.this.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "prod"
}