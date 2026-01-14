# modules/network/outputs.tf
output "vpc_id" {
  value       = aws_vpc.this_vpc.id
  description = "K8s Cluster VPC ID"
}

output "vpc_cidr" {
  value       = var.vpc_cidr
  description = "K8s Cluster VPC CIDR block"
}

output "public_subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "Public subnet ID"
}

output "private_subnet_id" {
  value       = aws_subnet.private_subnet.id
  description = "Private subnet ID"
}

output "nat_public_ip" {
  value       = aws_nat_gateway.this_nat.public_ip
  description = "NAT Gateway Public IP"
}
