locals {
  name          = "lambda_starter"
  author        = "Rahman Younus"
  email         = "rahman_95@live.co.uk"
  lambda_memory = 128

  tags = {
    Name      = "Lambda Starter Template"
    GitRepo   = "https://github.com/rahman95/terraform-lambda-typescript-starter"
    ManagedBy = "Terraform"
    Owner     = "${local.email}"
  }
}
