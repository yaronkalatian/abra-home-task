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