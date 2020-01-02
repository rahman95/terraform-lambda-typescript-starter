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

resource "aws_lambda_function" "lambda" {
  filename      = "${data.archive_file.function_archive.output_path}"
  function_name = "${local.name}"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "index.handler"

  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime     = "nodejs10.x"
  timeout     = "30"
  memory_size = "${local.lambda_memory}"

  environment {
    variables = {
      "EXAMPLE_SECRET" = "${var.example_secret}"
    }
  }
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_gateway_rest_api.execution_arn}/*/*"
}
