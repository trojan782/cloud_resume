output "api_endpoint" {
  value = "${aws_api_gateway_deployment.this.invoke_url}prod${aws_api_gateway_resource.this.path}"
}