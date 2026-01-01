variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets (typically 2 for multi-AZ)"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets (typically 2 for multi-AZ)"
  type        = number
  default     = 2
}

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