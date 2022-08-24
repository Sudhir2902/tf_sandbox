terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"

}

# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "vpc_dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "subnet_public_01" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-1"
  }
}

resource "aws_subnet" "subnet_public_02" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "dev-public-2"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "internet_gateway_dev" {
  vpc_id                  = aws_vpc.vpc_dev.id
  
  tags = {
    Name = "dev"
  }
}

#Creating Route Table for Internet Gateway
resource "aws_route_table" "route_table_dev-public" {
  vpc_id                  = aws_vpc.vpc_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_dev.id
  }

  tags = {
    "Name" = "dev-public-1"
  }

}

#Creating Route Associations public subnets
resource "aws_route_table_association" "route_table_association_dev-public-01" {
  subnet_id      = aws_subnet.subnet_public_01.id
  route_table_id = aws_route_table.route_table_dev-public.id
}

resource "aws_route_table_association" "route_table_association_dev-public-02" {
  subnet_id      = aws_subnet.subnet_public_02.id
  route_table_id = aws_route_table.route_table_dev-public.id

}

#Creating Security Group for ec2-instance
resource "aws_security_group" "security_group_dev-sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.vpc_dev.id
  #Incoming traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }

}

# Creating EC2 instances in public subnets
resource "aws_instance" "instance_public_inst_1" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_public_01.id
  vpc_security_group_ids = [aws_security_group.security_group_dev-sg.id]
  tags = {
    Name = "public_inst_1"
  }
}

resource "aws_instance" "instance_public_inst_2" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_public_02.id
  vpc_security_group_ids = [aws_security_group.security_group_dev-sg.id]
  tags = {
    Name = "public_inst_2"
  }
}
