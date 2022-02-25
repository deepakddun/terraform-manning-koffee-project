
resource "aws_vpc" "koffee_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.namespace
    By="terraform"
  }
}


resource "aws_subnet" "publicA" {
  vpc_id     = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    SubnetName = "${var.namespace}-publicA"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "AppA" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    SubnetName = "${var.namespace}-AppA"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "DbA" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.8.0/24"
  availability_zone = "us-east-1a"
  tags = {
    SubnetName = "${var.namespace}-DbA"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "publicB" {
  vpc_id     = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    SubnetName = "${var.namespace}-publicB"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "AppB" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.5.0/24"
  availability_zone = "us-east-1b"
  tags = {
    SubnetName = "${var.namespace}-AppB"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "DbB" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.9.0/24"
  availability_zone = "us-east-1b"
  tags = {
    SubnetName = "${var.namespace}-DbB"
    For = var.namespace
    By="terraform"
  }
}


resource "aws_subnet" "publicC" {
  vpc_id     = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    SubnetName = "${var.namespace}-publicC"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "AppC" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.6.0/24"
  availability_zone = "us-east-1c"
  tags = {
    SubnetName = "${var.namespace}-AppC"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_subnet" "DbC" {
  vpc_id = aws_vpc.koffee_vpc.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-east-1c"
  tags = {
    SubnetName = "${var.namespace}-DbC"
    For = var.namespace
    By="terraform"
  }
}

locals {
  subnets_public = [aws_subnet.publicA.id , aws_subnet.publicB.id , aws_subnet.publicC.id]
  subnets_private_app = [aws_subnet.AppA,aws_subnet.AppB,aws_subnet.AppC]
  subnets_private_db = [aws_subnet.DbA , aws_subnet.DbB , aws_subnet.DbC]
}

resource "aws_internet_gateway" "manning_koffee_MyIGW" {
  vpc_id = aws_vpc.koffee_vpc.id
  tags = {
    Name = "${var.namespace}-MyIGW"
    For = var.namespace
    By="terraform"
  }
}

resource "aws_eip" "manning_koffee_eip" {
  count = 3
  network_border_group = "us-east-1"
  tags = {
    Name = "${var.namespace}-eip-${count.index}"
    For = var.namespace
    By="terraform"
  }
  depends_on = [aws_internet_gateway.manning_koffee_MyIGW]
}

resource "aws_nat_gateway" "manning_koffee_nat_gateway" {
  count = length(local.subnets_public)
  subnet_id = local.subnets_public[count.index]
  allocation_id = aws_eip.manning_koffee_eip[count.index].id
  depends_on = [aws_eip.manning_koffee_eip]
}

resource "aws_route_table" "manning_koffee_route_table_public" {
  vpc_id = aws_vpc.koffee_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.manning_koffee_MyIGW.id
  }

  tags = {
    Name = "${var.namespace}-route-table-public-routetable"
    For = var.namespace
    By="terraform"
  }
  depends_on = [aws_internet_gateway.manning_koffee_MyIGW]
}



resource "aws_route_table_association" "manning_koffee_route_association_public" {
  count = length(local.subnets_public)
  route_table_id = aws_route_table.manning_koffee_route_table_public.id
  subnet_id = local.subnets_public[count.index]
}


resource "aws_route_table" "manning_koffee_route_table_private" {
  count = length(aws_nat_gateway.manning_koffee_nat_gateway)
  vpc_id = aws_vpc.koffee_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.manning_koffee_nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.namespace}-route-table-private-${count.index}"
    For = var.namespace
    By="terraform"
  }
  depends_on = [aws_nat_gateway.manning_koffee_nat_gateway]
}


resource "aws_route_table_association" "manning_koffee_route_association_private_app" {
  count = length(aws_route_table.manning_koffee_route_table_private)
  route_table_id = aws_route_table.manning_koffee_route_table_private[count.index].id
  subnet_id = local.subnets_private_app[count.index].id
  depends_on = [aws_route_table.manning_koffee_route_table_private]
}

resource "aws_route_table_association" "manning_koffee_route_association_private_db" {
  count = length(aws_route_table.manning_koffee_route_table_private)
  route_table_id = aws_route_table.manning_koffee_route_table_private[count.index].id
  subnet_id = local.subnets_private_db[count.index].id
  depends_on = [aws_route_table.manning_koffee_route_table_private]
}