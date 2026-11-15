#VPC
resource "aws_vpc" "Deepan-1" {
  cidr_block           = var.VPC-cidr
  enable_dns_support   = true #
  enable_dns_hostnames = true

  tags = {
    Name = "${var.Deepan}-VPC"
  }
}

#IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Deepan-1.id

  tags = {
    Name = "${var.Deepan}-IGW"
  }
}

#Public Subnets
resource "aws_subnet" "public-subnet" {
  count                   = length(var.public-subnet)
  vpc_id                  = aws_vpc.Deepan-1.id
  cidr_block              = var.public-subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.Deepan}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

#Private subnets
resource "aws_subnet" "private-subnet" {
  count                   = length(var.private-subnet)
  vpc_id                  = aws_vpc.Deepan-1.id
  cidr_block              = var.private-subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.Deepan}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#Router table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Deepan-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.Deepan}-router-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public-subnet)

  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

#Private route table association
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private-subnet)

  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

#Elastic IP for the NAT Gateway
resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = "${var.Deepan}-nat-eip"
  }
}

#NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = {
    Name = "${var.Deepan}-nat-gw"
  }
  depends_on = [aws_internet_gateway.IGW]
}

#NAT gateway - route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Deepan-1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.Deepan}-private-route"
  }
}

