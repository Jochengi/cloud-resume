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
    cloudfront_default_certificate = true # Uses the temporary default *.cloudfront.net URL
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
