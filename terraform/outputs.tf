output "s3" {
  value       = "${aws_s3_bucket.terraform-s3-lambda.id}"
  description = "The public IP of the web server"
}

output "s3-object-id" {
  value       = "${aws_s3_bucket_object.terraform-s3-object.id}"
  description = "The public IP of the web server"
}

output "s3-object-key" {
  value       = "${aws_s3_bucket_object.terraform-s3-object.key}"
  description = "The public IP of the web server"
}

output "api_base_url" {
  value       = "${aws_api_gateway_deployment.terraform-api-gateway-deployment.invoke_url}"
  description = "The public IP of the API"
}
