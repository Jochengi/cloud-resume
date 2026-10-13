output "cloudfront_url" {
  description = "The live secure HTTPS URL of your Cloud Resume website"
  value       = "https://${aws_cloudfront_distribution.resume_cdn.domain_name}"
}
