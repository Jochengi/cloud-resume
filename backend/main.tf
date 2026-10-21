# Specify the Cloud Provider & Region
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Provision the S3 Bucket Core Resource
resource "aws_s3_bucket" "resume_site" {
  bucket = "jochengi-cloud-resume-bucket"
}

# Configure the bucket for Static Website Hosting
resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.resume_site.id

  index_document {
    suffix = "index.html"
  }
}



# CloudFront Origin Access Control (OAC)
# Configures CloudFront to be the sole viewer of S3 bucket
resource "aws_cloudfront_origin_access_control" "site_oac" {
  name                              = "s3-site-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "resume_cdn" {
  aliases = ["jonathaneng.dev"]

  origin {
    domain_name              = aws_s3_bucket.resume_site.bucket_regional_domain_name
    origin_id                = "S3-ResumeOrigin"
    origin_access_control_id = aws_cloudfront_origin_access_control.site_oac.id
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-ResumeOrigin"
    viewer_protocol_policy = "redirect-to-https" # Forces SSL encryption security

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn # Point to new SSL cert
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"               # Industry-standard secure cryptographic baseline
  }
}



# Generate secure JSON IANM Policy document (enforces principle of least privelege)
data "aws_iam_policy_document" "allow_cloudfront_oac" {
  statement {
    sid       = "AllowCloudFrontServicePrincipalReadOnly"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.resume_site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.resume_cdn.arn]
    }
  }
}

# Attach IAM Policy Document to Live S3 Bucket
resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.resume_site.id
  policy = data.aws_iam_policy_document.allow_cloudfront_oac.json
}

# Create Route 53 DNS Management Container
resource "aws_route53_zone" "primary" {
  name = "jonathaneng.dev"
}

# Request Free Public SSL Certificate from AWS
resource "aws_acm_certificate" "cert" {
  domain_name       = "jonathaneng.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Automate DNS Verification inside Route 53 Hosted Zone
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

# Wait for AWS to successfully validate and activate certificate
resource "aws_acm_certificate_validation" "cert_verify" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Create Final Route 53 A-Record Alias to point domain to CloudFront
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "jonathaneng.dev"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.resume_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}



# Create DynamoDB table
resource "aws_dynamodb_table" "visitor_counter" {
  name         = "cloud_resume_visitor_counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Automate zipping of Python backend application file
data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "${path.module}/lambdas/cdn_counter.py"
  output_path = "${path.module}/lambdas/cdn_counter.zip"
}

# Create IAM role and authorize Lambda service to wear badge
resource "aws_iam_role" "lambda_role" {
  name = "cloud-resume-lambda-executor"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create permission policy target
resource "aws_iam_policy" "lambda_dynamo_policy" {
  name        = "cloud-resume-lambda-dynamodb"
  description = "Grants the resume Lambda function targeted access to write data to DynamoDB"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${aws_dynamodb_table.visitor_counter.arn}", # Dynamic address lock
          "arn:aws:logs:*:*:*" # Write logs
        ]
      }
    ]
  })
}

# Clip the completed permission policy onto Lambda security role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamo_policy.arn
}

# Create Lambda environment
resource "aws_lambda_function" "visitor_counter_api" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "cloud-resume-api"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.12"
  handler          = "cdn_counter.lambda_handler"

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.visitor_counter.name
    }
  }
}



# Create Global HTTP API Gateway Conatiner Shell
resource "aws_apigatewayv2_api" "http_api" {
  name          = "cloud-resume-http-api"
  protocol_type = "HTTP"

  # Matches cdn_counter.py headers
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type"]
    max_age       = 300
  }
}

# Create Integration between Gateway and Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.visitor_counter_api.invoke_arn
}

# Define Explicit API URL Route Pathway
resource "aws_apigatewayv2_route" "counter_route" {
  api_id = aws_apigatewayv2_api.http_api.id
  route_key  = "GET /views"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create permission for Gateway to access Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Deploy API Live onto Root URL Environmental Stage
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"   # Automatically serves routes on root domain path
  auto_deploy = true
}