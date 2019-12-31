output "api_base_url" {
  value       = "${aws_api_gateway_deployment.api_gateway_deployment.invoke_url}"
  description = "The public IP of the API"
}
