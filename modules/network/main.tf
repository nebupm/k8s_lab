# ============================================
# modules/network/main.tf
# ============================================

resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.this_vpc.id
  cidr_block              = var.public_subnets
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.vpc_name}-public-subnet"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = var.private_subnets
  availability_zone = aws_subnet.public_subnet.availability_zone

  tags = {
    Name        = "${var.vpc_name}-private-subnet"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id
  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this_igw]
  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "this_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.this_igw]
  tags = {
    Name        = "${var.vpc_name}-nat-gateway"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

# Route table for public subnet (uses IGW)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_igw.id
  }

  # Add route through NAT Gateway for return traffic
  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Route table for private subnet (uses NAT)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this_nat.id
  }

  tags = {
    Name        = "${var.vpc_name}-private-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
