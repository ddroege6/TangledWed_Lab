resource "aws_vpc" "vpc" {
  cidr_block           = "10.80.0.0/16"
  enable_dns_hostnames = true
  tags                 = merge(local.tags, { Name = "${local.name}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.name}-igw" })
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.80.0.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true
  tags                    = merge(local.tags, { Name = "${local.name}-public-a" })
}
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.80.1.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true
  tags                    = merge(local.tags, { Name = "${local.name}-public-b" })
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.80.10.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]
  tags              = merge(local.tags, { Name = "${local.name}-private-a" })
}
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.80.11.0/24"
  availability_zone = data.aws_availability_zones.azs.names[1]
  tags              = merge(local.tags, { Name = "${local.name}-private-b" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.name}-public-rt" })
}
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "pub_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id
  tags          = merge(local.tags, { Name = "${local.name}-nat" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.name}-private-rt" })
}
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
resource "aws_route_table_association" "priv_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "priv_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
