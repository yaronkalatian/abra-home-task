output "api_gateway_endpoint" {
  description = "Public API Gateway endpoint"
  value       = module.api_gateway.api_endpoint
}

output "alb_dns_name" {
  description = "Internal ALB DNS name"
  value       = module.alb.alb_dns_name
}