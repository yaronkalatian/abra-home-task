output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.abra.name
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.abra.name
}

output "security_group_id" {
  description = "Security group ID attached to ECS tasks"
  value       = aws_security_group.ecs.id
}