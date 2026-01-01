resource "aws_vpc" "abra" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "abra" {
  vpc_id = aws_vpc.abra.id
}

data "aws_availability_zones" "available" {
  
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.abra.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.abra.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_nat_gateway" "abra" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}
