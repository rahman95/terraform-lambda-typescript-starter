data "archive_file" "function_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/dist"
  output_path = "${path.module}/../lambda/dist/function.zip"
}

resource "aws_lambda_layer_version" "dependency_layer" {
  filename            = "${path.module}/../dist/layers/layers.zip"
  layer_name          = "dependency_layer"
  compatible_runtimes = ["nodejs10.x"]
  source_code_hash    = "${base64sha256(file("${path.module}/../dist/layers/layers.zip"))}"
}

resource "aws_lambda_function" "terraform-lambda" {
  filename      = "${data.archive_file.function_archive.output_path}"
  function_name = "test-lambda"
  role          = "${aws_iam_role.terraform-iam-role.arn}"
  handler       = "index.handler"

  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime = "nodejs10.x"
  timeout = "30"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role" "terraform-iam-role" {
  name = "terraform-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "terraform-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.terraform-lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.terraform-api-gateway-rest-api.execution_arn}/*/*"
}
