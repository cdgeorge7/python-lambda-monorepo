terraform {
  backend "s3" {
    bucket = "terraform-state-example-bucket"
    key    = "dev/modules/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-state-example-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.0"
    }
  }
}


module "use_other_lambda" {
  source = "../../modules/use_other_lambda"
}

output "other_url" {
  value = module.use_other_lambda.url
}


module "use_proxy_lambda" {
  source = "../../modules/use_proxy_lambda"
}

output "proxy_url" {
  value = module.use_proxy_lambda.url
}
