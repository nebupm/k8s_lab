# Define the region for AWS resources
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
# Define the region for AWS resources
variable "aws_profile" {
  description = "The AWS profile to use for running the code"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "CIDR ranges allowed SSH access"
  type        = list(string)
}


variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "k8s-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = string
  default     = "10.0.10.0/24"
}
