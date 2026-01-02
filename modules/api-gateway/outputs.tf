output "api_endpoint" {
  value = aws_apigatewayv2_api.abra.api_endpoint
}

output "vpc_link_security_group_id" {
  description = "Security group ID used by API Gateway VPC Link"
  value       = aws_security_group.vpc_link.id
}
