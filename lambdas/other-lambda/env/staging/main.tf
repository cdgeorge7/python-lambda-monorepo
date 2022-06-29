terraform {
  backend "s3" {
    bucket = "terraform-state-example-bucket-staging"
    key    = "lambda/other-lambda/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-state-example-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.1"
  # insert the 32 required variables here
  function_name = "other-lambda"
  description   = "Simple lambda that returns the event"
  handler       = "main.handler"
  runtime       = "python3.9"
  publish       = true

  source_path = "../../code"

  store_on_s3 = true
  s3_bucket   = "lambda-source-bucket-lskjadf"
}

output "s3_object" {
  value = module.lambda.s3_object
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}
