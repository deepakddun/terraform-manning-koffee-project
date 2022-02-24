
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