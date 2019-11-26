resource "aws_api_gateway_rest_api" "terraform-api-gateway-rest-api" {
  name        = "terraform-api-gateway"
  description = "Terraform Api Gateway for Lambda"
}

resource "aws_api_gateway_resource" "terraform-api-gateway" {
  rest_api_id = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "terraform-api-gateway-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  resource_id   = "${aws_api_gateway_resource.terraform-api-gateway.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "terraform-api-gateway-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  resource_id = "${aws_api_gateway_method.terraform-api-gateway-method.resource_id}"
  http_method = "${aws_api_gateway_method.terraform-api-gateway-method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.terraform-lambda.invoke_arn}"
}

resource "aws_api_gateway_method" "terraform-api-gateway-root-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  resource_id   = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "terraform-api-gateway-root-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  resource_id = "${aws_api_gateway_method.terraform-api-gateway-root-method.resource_id}"
  http_method = "${aws_api_gateway_method.terraform-api-gateway-root-method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.terraform-lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "terraform-api-gateway-deployment" {
  depends_on = [
    "aws_api_gateway_integration.terraform-api-gateway-integration",
    "aws_api_gateway_integration.terraform-api-gateway-root-integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.id}"
  stage_name  = "test"
}
