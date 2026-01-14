variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR ranges allowed SSH access"
  type        = list(string)
}
