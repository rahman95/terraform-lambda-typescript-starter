resource "aws_lambda_function" "terraform-lambda" {
  #   filename = "../lambda/dist/lambda.zip"

  s3_bucket = "${aws_s3_bucket.terraform-s3-lambda.id}"
  s3_key    = "${aws_s3_bucket_object.terraform-s3-object.key}"

  function_name = "test-lambda"

  role    = "${aws_iam_role.terraform-iam-role.arn}"
  handler = "index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #   source_code_hash = "${filebase64sha256("${aws_s3_bucket_object.terraform-s3-object.key}")}"

  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime = "nodejs10.x"
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
