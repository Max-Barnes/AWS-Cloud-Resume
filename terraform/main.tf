#AWS Provider

terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
}

provider "aws" {
  region = "us-east-2"
}
# create the s3 bucket

resource "aws_s3_bucket" "s3" {
  bucket = "beezywebsite-123213"

    # tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.s3.id
    versioning_configuration {
      status = "Enabled"
    }
}
# make it private

resource "aws_s3_bucket_public_access_block" "privacy" {
    bucket      = aws_s3_bucket.s3.id

    block_public_acls           = true
    block_public_policy         = true
    ignore_public_acls          = true
    restrict_public_buckets     = true
} 


resource "aws_s3_object" "upload-index" {
    bucket     = aws_s3_bucket.s3.id
    key        = "index.html"
    source     = "../site/index.html"
}
resource "aws_s3_object" "upload-script" {
    bucket     = aws_s3_bucket.s3.id
    key        = "script.js"
    source     = "../site/script.js"
}
resource "aws_s3_object" "upload-styles" {
    bucket     = aws_s3_bucket.s3.id
    key        = "styles.css"
    source     = "../site/styles.css"
}

resource "aws_s3_object" "upload-background" {
    bucket     = aws_s3_bucket.s3.id
    key        = "images/background.gif"
    source     = "../site/images/background.gif"
}

resource "aws_s3_object" "upload-email-icon" {
    bucket     = aws_s3_bucket.s3.id
    key        = "images/email.svg"
    source     = "../site/images/email.svg"
}

resource "aws_s3_object" "upload-github-icon" {
    bucket     = aws_s3_bucket.s3.id
    key        = "images/github.svg"
    source     = "../site/images/github.svg"
}

resource "aws_s3_object" "upload-linkedin-icon" {
    bucket     = aws_s3_bucket.s3.id
    key        = "images/linkedin.svg"
    source     = "../site/images/linkedin.svg"
}

resource "aws_s3_bucket_website_configuration" "configuration" {
    bucket     = aws_s3_bucket.s3.id
    index_document {
      suffix   = "index.html"
    }
}

# allow cloudfront access to s3

data "aws_iam_policy_document" "origin-policy" {
    statement {
      sid = "AllowCloudFrontServicePrincipalReadWrite"
      effect = "Allow"
    

    principals {
        type = "Service"
        identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
        "s3:GetObject",
        "s3:PutObject",
    ]

    resources = [
        "${aws_s3_bucket.s3.arn}/*",
    ]

    condition {
      test = "StringEquals"
      variable = "AWS: SourceArn"
      values = [aws_cloudfront_distribution.s3-distribution.arn]
    }
    }
}

resource "aws_s3_bucket_policy" "s3" {
    bucket = aws_s3_bucket.s3.bucket
    policy = data.aws_iam_policy_document.origin-policy.json
}
# the https infra

data "aws_acm_certificate" "maxbarnesdotcom" {
    region = "us-east-1"
    domain = "test.maxbarnes.com"
    statuses = ["ISSUED"]
}

resource "aws_cloudfront_origin_access_control" "default" {
    name = "default-oac"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
  
}

#TODO: change this into the right domain after i verify it works correctly
locals {
    s3_origin_id = "maxS3Origin"
    domain = "test.maxbarnes.com"
}

resource "aws_cloudfront_distribution" "s3-distribution" {

    origin {
      domain_name = aws_s3_bucket.s3.bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.default.id
      origin_id = local.s3_origin_id
    }

    enabled = true
    is_ipv6_enabled = false
    comment = "bagingi"
    default_root_object = "index.html"

    aliases = ["${local.domain}"]

    default_cache_behavior {
      allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = local.s3_origin_id
    

    forwarded_values {
        query_string = false
    

    cookies {
        forward = "none"
    }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    }

    ordered_cache_behavior {
      path_pattern = "*"
      allowed_methods = ["GET","HEAD","OPTIONS"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = local.s3_origin_id

      forwarded_values {
        query_string = false
        headers = ["Origin"]

        cookies {
          forward = "none"
        }
      }
      min_ttl = 0
      default_ttl = 86400
      max_ttl = 31536000
      compress = true
      viewer_protocol_policy = "redirect-to-https"
    }

    restrictions {
      geo_restriction {
        restriction_type = "whitelist"
        locations = ["US", "CA", "GB", "DE"]
      }
    }

    viewer_certificate {
      acm_certificate_arn = data.aws_acm_certificate.maxbarnesdotcom.arn
      ssl_support_method = "sni-only"
    }
}

# database infrastructure (needs tested)
resource "aws_dynamodb_table" "visitor-counter" {
  name = "Visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "Visits"

  attribute {
    name = "Visits"
    type = "N"
  }

}

resource "aws_dynamodb_table_item" "item" {
  table_name = aws_dynamodb_table.visitor-counter.name
  hash_key = aws_dynamodb_table.visitor-counter.hash_key

  item = "" #TODO
}
# API infrastructure

resource "aws_apigatewayv2_api" "api" {
  name = "accessDatabaseApi"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://maxbarnes.com", "https://max-barnes.com"]
    allow_methods = ["GET","POST"]
  }
}

#lambda functions, will need iam role

resource "aws_iam_role" "lambdaExec" {
  name = "lambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service: "lambda.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.lambdaExec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "get" {
  filename = "../lambda/Lambda-getWebsiteVisitors.zip"
  function_name = "getWebsiteVisitors"

  role = aws_iam_role.lambdaExec.arn
  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"
  timeout = 10
}


resource "aws_lambda_function" "write" {
  filename = "../lambda/Lambda-writeToWebsiteVisitors.zip"
  function_name = "writeToWebsiteVisitors"

  role = aws_iam_role.lambdaExec.arn
  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"
  timeout = 10
}

resource "aws_apigatewayv2_integration" "get-integration" {
    api_id = aws_apigatewayv2_api.api.id
    integration_type = "AWS_PROXY"

    integration_uri = aws_lambda_function.get.invoke_arn
}

resource "aws_apigatewayv2_integration" "write-integration" {
    api_id = aws_apigatewayv2_api.api.id
    integration_type = "AWS_PROXY"

    integration_uri = aws_lambda_function.write.invoke_arn
}