resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  name        = "api_gateway"
  description = "Api Gateway for Lambda"
}

resource "aws_api_gateway_resource" "api_gateway" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_gateway_rest_api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.api_gateway.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  resource_id = "${aws_api_gateway_method.api_gateway_method.resource_id}"
  http_method = "${aws_api_gateway_method.api_gateway_method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_api_gateway_method" "api_gateway_root_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.api_gateway_rest_api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_root_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  resource_id = "${aws_api_gateway_method.api_gateway_root_method.resource_id}"
  http_method = "${aws_api_gateway_method.api_gateway_root_method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    "aws_api_gateway_integration.api_gateway_integration",
    "aws_api_gateway_integration.api_gateway_root_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_rest_api.id}"
  stage_name  = "test"
}
