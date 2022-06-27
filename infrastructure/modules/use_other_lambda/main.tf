
data "terraform_remote_state" "lambda_other_lambda_source" {
  backend = "s3"

  config = {
    bucket = "terraform-state-example-bucket"
    key    = "lambda/other-lambda/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = data.terraform_remote_state.lambda_other_lambda_source.outputs.lambda_function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_headers = ["*"]
    allow_methods = ["*"]
    max_age       = 3600
  }
}

output "url" {
  value = aws_lambda_function_url.this.function_url
}

# resource "aws_cloudfront_distribution" "this" {
#   origin {
#     domain_name = replace(replace(aws_lambda_function_url.this.function_url, "https://", ""), "/", "")
#     origin_id   = aws_lambda_function_url.this.function_name

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "https-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }
#   enabled     = true
#   price_class = "PriceClass_100"
#   default_cache_behavior {
#     allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
#     cached_methods   = ["HEAD", "GET", "OPTIONS"]
#     target_origin_id = aws_lambda_function_url.this.function_name
#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }
#     viewer_protocol_policy = "redirect-to-https"
#   }
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
# }
