variable "app_name" {
  description = "Application name"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for the VPC Link"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener to integrate with API Gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group association"
  type        = string
}

variable "alb_dns_name" {
  type = string
}