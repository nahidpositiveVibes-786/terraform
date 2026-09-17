resource "aws_vpc" "new_vpc"{
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "prj_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.new_vpc.id
    cidr_block = "10.0.0.0/25"
    availability_zone ="us-east-1a"
    tags = {
        Name = "prj_public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.new_vpc.id
    cidr_block = "10.0.0.128/25"
    availability_zone ="us-east-1a"
    tags = {
        Name = "prj_private_subnet"
    }
}

resource "aws_internet_gateway" "prj_IG"{
    vpc_id = aws_vpc.new_vpc.id
    tags = {
      Name = "prj_IG"
    }
}

resource "aws_route_table" "IG_rtb" {
    vpc_id = aws_vpc.new_vpc.id
    tags = {
        Name = "IG_rtb"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prj_IG.id
    }
}

resource "aws_route_table" "NAT_rtb" {
    vpc_id = aws_vpc.new_vpc.id
    tags = {
        Name = "NAT_rtb"
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat1.id
    }
}

resource "aws_route_table_association" "prj_rtb_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.IG_rtb.id
}

resource "aws_route_table_association" "prj_rtb_association2" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.NAT_rtb.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat1"{
    allocation_id = aws_eip.nat_eip.id
    tags = {
        Name = "prj_NAT"
    }
    subnet_id = aws_subnet.public_subnet.id
}