resource "aws_vpc" "dev_vpc"{
    cidr_block = var.cidr
    tags = {
        Name = "dev_vpc"
    }
}

resource "aws_vpc" "prj_vpc"{
    cidr_block = var.cidr
    tags = {
        Name = "prj_vpc"
    }
}

resource "aws_subnet" "subnet1"{
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.subnet_cidr 
    tags = {
        Name = "subnet1"
    }
}