terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "terraform-user"

}

# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-1"
  }
}

resource "aws_subnet" "dev-public-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "dev-public-2"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

#Creating Route Table for Internet Gateway
resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    "Name" = "dev-public-1"
  }

}

#Creating Route Associations public subnets
resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-2-a" {
  subnet_id      = aws_subnet.dev-public-2.id
  route_table_id = aws_route_table.dev-public.id

}

#Creating Security Group for ec2-instance
resource "aws_security_group" "dev-sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.dev.id
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
resource "aws_instance" "public_inst_1" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev-public-1.id
  vpc_security_group_ids = [aws_security_group.dev-sg.id]
  tags = {
    Name = "public_inst_1"
  }
}

resource "aws_instance" "public_inst_2" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev-public-2.id
  vpc_security_group_ids = [aws_security_group.dev-sg.id]
  tags = {
    Name = "public_inst_2"
  }
}
