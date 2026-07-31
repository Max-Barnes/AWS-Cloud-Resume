#AWS Provider
# moved terraform block to providers.tf to hide backend config but imagine it's here

provider "aws" {
  region = var.region
}
# imports work better than re creating

# import the s3 bucket

import {
  to = aws_s3_bucket.s3
  id = "maxbeezywebsite"
}


# the https infra

import {
  to = aws_cloudfront_distribution.s3-distribution
  id = "E19OV94394U98B"
}

locals {
    s3_origin_id = "maxS3Origin"
    domain = "maxbarnes.com"
}

# database infrastructure (needs tested)

import {
  to = aws_dynamodb_table.table
  id = "website-visitors"
}

# API infrastructure

import {
  to = aws_apigatewayv2_api.api
  id = "ltzydqs8uk"
}

import {
  to = aws_apigatewayv2_integration.get-integration
  id = "ltzydqs8uk/td0990r"
}

import {
  to = aws_apigatewayv2_integration.write-integration
  id = "ltzydqs8uk/95kueya"
}


# lambda 
import {
  to = aws_lambda_function.write-lambda
  id = "writeToWebsiteVisitors"
}

import {
  to = aws_lambda_function.get-lambda
  id = "getWebsiteVisitors"
}

import {
  to = aws_iam_role.get-role
  id = "getWebsiteVisitors-role-6n98u2ju"
}

import {
  to = aws_iam_role.write-role
  id = "getAndWriteToWebsiteVisitors"
}

import {
  to = aws_iam_role_policy_attachment.get-attachment
  id = "getAndWriteToWebsiteVisitors/arn:aws:iam::732555349688:policy/getAndWriteToWebsiteVisitorsPolicy"
}

import {
  to = aws_iam_role_policy_attachment.write-attachment
  id = "getWebsiteVisitors-role-6n98u2ju/arn:aws:iam::732555349688:policy/getWebsiteVisitors-role-6n98u2juPolicy"
}


# __generated__ by Terraform from "getWebsiteVisitors-role-6n98u2ju/arn:aws:iam::732555349688:policy/getWebsiteVisitors-role-6n98u2juPolicy"
resource "aws_iam_role_policy_attachment" "write-attachment" {
  policy_arn = "arn:aws:iam::732555349688:policy/getWebsiteVisitors-role-6n98u2juPolicy"
  role       = "getWebsiteVisitors-role-6n98u2ju"
}

# __generated__ by Terraform from "getAndWriteToWebsiteVisitors/arn:aws:iam::732555349688:policy/getAndWriteToWebsiteVisitorsPolicy"
resource "aws_iam_role_policy_attachment" "get-attachment" {
  policy_arn = "arn:aws:iam::732555349688:policy/getAndWriteToWebsiteVisitorsPolicy"
  role       = "getAndWriteToWebsiteVisitors"
}

# __generated__ by Terraform from "getAndWriteToWebsiteVisitors"
resource "aws_iam_role" "write-role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = null
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "getAndWriteToWebsiteVisitors"
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

# __generated__ by Terraform from "getWebsiteVisitors-role-6n98u2ju"
resource "aws_iam_role" "get-role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = null
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "getWebsiteVisitors-role-6n98u2ju"
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}


# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "ltzydqs8uk"
resource "aws_apigatewayv2_api" "api" {
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  credentials_arn              = null
  description                  = "Created by AWS Lambda"
  disable_execute_api_endpoint = false
  fail_on_warnings             = null
  ip_address_type              = "ipv4"
  name                         = "writeToWebsiteVisitors-API"
  protocol_type                = "HTTP"
  region                       = "us-east-2"
  route_key                    = null
  route_selection_expression   = "$request.method $request.path"
  tags                         = {}
  tags_all                     = {}
  target                       = null
  version                      = null
  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_methods     = ["GET", "POST"]
    allow_origins     = ["*", "https://max-barnes.com", "https://maxbarnes.com"]
    expose_headers    = []
    max_age           = 0
  }
}

# __generated__ by Terraform
resource "aws_lambda_function" "write-lambda" {
  architectures                      = ["x86_64"]
  code_sha256                        = "4hHdytr3EEoa68+7KtwhH98s7yv6yXZHxmOLoi19904="
  code_signing_config_arn            = null
  description                        = null
  filename                           = "../lambda/Lambda-writeToWebsiteVisitors.zip"
  function_name                      = "writeToWebsiteVisitors"
  handler                            = "lambda_function.lambda_handler"
  image_uri                          = null
  kms_key_arn                        = null
  layers                             = []
  memory_size                        = 128
  package_type                       = "Zip"
  publish                            = null
  publish_to                         = null
  region                             = "us-east-2"
  replace_security_groups_on_destroy = null
  replacement_security_group_ids     = null
  reserved_concurrent_executions     = -1
  role                               = "arn:aws:iam::732555349688:role/getAndWriteToWebsiteVisitors"
  runtime                            = "python3.14"
  s3_bucket                          = null
  s3_key                             = null
  s3_object_version                  = null
  skip_destroy                       = false
  source_kms_key_arn                 = null
  tags                               = {}
  tags_all                           = {}
  timeout                            = 3
  ephemeral_storage {
    size = 512
  }
  logging_config {
    application_log_level = null
    log_format            = "Text"
    log_group             = "/aws/lambda/writeToWebsiteVisitors"
    system_log_level      = null
  }
  tracing_config {
    mode = "PassThrough"
  }
}

# __generated__ by Terraform from "ltzydqs8uk/95kueya"
resource "aws_apigatewayv2_integration" "write-integration" {
  api_id                        = "ltzydqs8uk"
  connection_id                 = null
  connection_type               = "INTERNET"
  content_handling_strategy     = null
  credentials_arn               = null
  description                   = null
  integration_method            = "POST"
  integration_subtype           = null
  integration_type              = "AWS_PROXY"
  integration_uri               = "arn:aws:lambda:us-east-2:732555349688:function:writeToWebsiteVisitors"
  passthrough_behavior          = null
  payload_format_version        = "2.0"
  region                        = "us-east-2"
  request_parameters            = {}
  request_templates             = {}
  template_selection_expression = null
  timeout_milliseconds          = 30000
}

# __generated__ by Terraform
resource "aws_lambda_function" "get-lambda" {
  architectures                      = ["x86_64"]
  code_sha256                        = "OiZipnCtIi11Ebibo9WLqfFW+ebWSZXuOMZz2cNqmO4="
  code_signing_config_arn            = null
  description                        = null
  filename                           = "../lambda/Lambda-getWebsiteVisitors.zip"
  function_name                      = "getWebsiteVisitors"
  handler                            = "lambda_function.lambda_handler"
  image_uri                          = null
  kms_key_arn                        = null
  layers                             = []
  memory_size                        = 128
  package_type                       = "Zip"
  publish                            = null
  publish_to                         = null
  region                             = "us-east-2"
  replace_security_groups_on_destroy = null
  replacement_security_group_ids     = null
  reserved_concurrent_executions     = -1
  role                               = "arn:aws:iam::732555349688:role/getWebsiteVisitors-role-6n98u2ju"
  runtime                            = "python3.14"
  s3_bucket                          = null
  s3_key                             = null
  s3_object_version                  = null
  skip_destroy                       = false
  source_kms_key_arn                 = null
  tags                               = {}
  tags_all                           = {}
  timeout                            = 3
  ephemeral_storage {
    size = 512
  }
  logging_config {
    application_log_level = null
    log_format            = "Text"
    log_group             = "/aws/lambda/getWebsiteVisitors"
    system_log_level      = null
  }
  tracing_config {
    mode = "PassThrough"
  }
}

# __generated__ by Terraform from "E19OV94394U98B"
resource "aws_cloudfront_distribution" "s3-distribution" {
  aliases             = ["maxbarnes.com", "www.maxbarnes.com"]
  anycast_ip_list_id  = null
  comment             = null
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  staging             = false
  tags = {
    Name = "bucket boy"
  }
  tags_all = {
    Name = "bucket boy"
  }
  wait_for_deployment = true
  web_acl_id          = null
  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "maxbeezywebsite.s3.us-east-2.amazonaws.com-mhgs7n49x6t"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    grpc_config {
      enabled = false
    }
  }
  origin {
    connection_attempts         = 3
    connection_timeout          = 10
    domain_name                 = "maxbeezywebsite.s3.us-east-2.amazonaws.com"
    origin_access_control_id    = "E5X54A46CQ8R0"
    origin_id                   = "maxbeezywebsite.s3.us-east-2.amazonaws.com-mhgs7n49x6t"
    origin_path                 = null
    response_completion_timeout = 0
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:732555349688:certificate/81a46870-caa4-4ba9-afa0-f03b9459fb11"
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

# __generated__ by Terraform from "ltzydqs8uk/td0990r"
resource "aws_apigatewayv2_integration" "get-integration" {
  api_id                        = "ltzydqs8uk"
  connection_id                 = null
  connection_type               = "INTERNET"
  content_handling_strategy     = null
  credentials_arn               = null
  description                   = null
  integration_method            = "POST"
  integration_subtype           = null
  integration_type              = "AWS_PROXY"
  integration_uri               = "arn:aws:lambda:us-east-2:732555349688:function:getWebsiteVisitors"
  passthrough_behavior          = null
  payload_format_version        = "2.0"
  region                        = "us-east-2"
  request_parameters            = {}
  request_templates             = {}
  template_selection_expression = null
  timeout_milliseconds          = 30000
}

# __generated__ by Terraform
resource "aws_dynamodb_table" "table" {
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false
  hash_key                    = "ID"
  name                        = "website-visitors"
  range_key                   = null
  read_capacity               = 0
  region                      = "us-east-2"
  restore_backup_arn          = null
  restore_date_time           = null
  restore_source_name         = null
  restore_source_table_arn    = null
  restore_to_latest_time      = null
  stream_enabled              = false
  table_class                 = "STANDARD"
  tags                        = {}
  tags_all                    = {}
  write_capacity              = 0
  attribute {
    name = "ID"
    type = "S"
  }
  point_in_time_recovery {
    enabled                 = false
  }
  ttl {
    attribute_name = null
    enabled        = false
  }
}

# __generated__ by Terraform from "maxbeezywebsite"
resource "aws_s3_bucket" "s3" {
  bucket              = "maxbeezywebsite"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-east-2"
  tags                = {}
  tags_all            = {}
}

