resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.vpc1.id
}

resource "aws_subnet" "private_subnet" {
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.vpc1.id
}

resource "aws_internet_gateway" "dev_IG" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "dev_IG"
  }
}

resource "aws_route_table" "IG_rtb" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_IG.id
  }
  tags = {
    Name = "IG_rtb"
  }
}

resource "aws_route_table_association" "public_RTB_IG" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.IG_rtb.id
}

resource "aws_nat_gateway" "nat_resurce" {
  vpc_id            = aws_vpc.vpc1.id
  availability_mode = "regional"
  tags = {
    Name = "dev_nat"
  }
}

resource "aws_route_table" "NAT_rtb1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_resurce.id
  }
  tags = {
    Name = "NAT_rtb"
  }
}

resource "aws_route_table_association" "private_rtb_asso_resource" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.NAT_rtb1.id
}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_instance" {
  ami                    = "ami-0e34b50e714a297f1"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  tags = {
    Name = "bastion_host"
  }
}