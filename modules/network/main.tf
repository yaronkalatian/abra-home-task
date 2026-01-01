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


resource "aws_eip" "nat" {
  count = var.public_subnet_count
  tags = {
    Name = "${var.app_name}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "abra" {
  count         = var.public_subnet_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

    tags = {
    Name = "${var.app_name}-nat-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = "private-rt" }
}

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id   # adjust for multi-AZ if needed
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = var.private_subnets[count.index]
  route_table_id = aws_route_table.private.id
}