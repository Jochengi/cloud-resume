output "cloudfront_url" {
  description = "The live secure HTTPS URL of my Cloud Resume website"
  value       = "https://${aws_cloudfront_distribution.resume_cdn.domain_name}"
}

output "api_endpoint" {
  description = "The secure public HTTPS web link to trigger my backend visitor counter API"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "github_actions_role_arn" {
  description = "The exact ARN identity code for my GitHub runner badge"
  value       = aws_iam_role.github_actions_role.arn
}