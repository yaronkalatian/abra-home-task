output "api_gateway_endpoint" {
  description = "Public API Gateway endpoint"
  value       = module.api_gateway.api_endpoint
}
