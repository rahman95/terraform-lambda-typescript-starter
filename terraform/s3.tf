resource "aws_s3_bucket" "terraform-s3-lambda" {
  bucket = "terraform-s3-lambda"
  acl    = "private"

  tags = {
    Name = "terraform-s3-lambda"
  }
}
