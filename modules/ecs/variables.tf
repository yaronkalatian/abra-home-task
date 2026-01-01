variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS tasks"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for ECS Fargate tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB allowed to access ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN used by the ECS service"
  type        = string
}


variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 2
}

variable "alb_listener_arn" {
  type = string
}