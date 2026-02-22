# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# パブリックサブネット（マルチAZ）
resource "aws_subnet" "public" {
  for_each = {
    "01" = { az = "ap-northeast-1a", cidr = "10.0.0.0/20" }
    "02" = { az = "ap-northeast-1c", cidr = "10.0.16.0/20" }
  }

  vpc_id                  = aws_vpc.main.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet-public-${each.key}"
  }
}

# プライベートサブネット（マルチAZ）
resource "aws_subnet" "private" {
  for_each = {
    "01" = { az = "ap-northeast-1a", cidr = "10.0.64.0/20" }
    "02" = { az = "ap-northeast-1c", cidr = "10.0.80.0/20" }
  }

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = {
    Name = "${var.project_name}-subnet-private-${each.key}"
  }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# パブリックサブネット用ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway用Elastic IP
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip-nat-${each.key}"
  }
}

# NAT Gateway（AZごと）
resource "aws_nat_gateway" "main" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.project_name}-ngw-${each.key}"
  }
}

# プライベートサブネット用ルートテーブル（AZごと）
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }

  tags = {
    Name = "${var.project_name}-rt-private-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
