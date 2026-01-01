variable "app_name" {
  description = "Application name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for the internal ALB"
  type        = list(string)
}

variable "vpc_link_sg_id" {
  description = "Security group ID used by API Gateway VPC Link"
  type        = string
}