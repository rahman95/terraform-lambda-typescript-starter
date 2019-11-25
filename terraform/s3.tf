resource "aws_s3_bucket" "terraform-s3-lambda" {
  bucket = "terraform-s3-lambda"
  acl    = "private"

  tags = {
    Name = "terraform-s3-lambda"
  }
}

resource "aws_s3_bucket_object" "terraform-s3-object" {
  bucket = "${aws_s3_bucket.terraform-s3-lambda.id}"
  key    = "lambda.zip"
  source = "../lambda/dist/lambda.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = "${filemd5("../lambda/dist/lambda.zip")}"
}
