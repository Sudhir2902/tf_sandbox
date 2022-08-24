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
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.vpc-tags
}

# Creating Public Subnets in VPC
resource "aws_subnet" "subnet_public_01" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = var.subnet1_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.subnet1-AZ
  tags                    = var.subnet1-tags
}

resource "aws_subnet" "subnet_public_02" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = var.subnet2_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.subnet1-AZ

  tags = var.subnet2-tags
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "internet_gateway_dev" {
  vpc_id                  = aws_vpc.vpc_dev.id
  tags = var.IG-tags
}

#Creating Route Table for Internet Gateway
resource "aws_route_table" "route_table_dev-public" {
  vpc_id                  = aws_vpc.vpc_dev.id
  route {
    cidr_block = var.IG_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway_dev.id
  }

  tags = var.IG-tags

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
  name   = var.security_group_dev-sg-name
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

  tags = var.sg-tags

}

# Creating EC2 instances in public subnets
resource "aws_instance" "instance_public_inst_1" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_public_01.id
  vpc_security_group_ids = [aws_security_group.security_group_dev-sg.id]
  tags                   = var.instance-tags
}

resource "aws_instance" "instance_public_inst_2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_public_02.id
  vpc_security_group_ids = [aws_security_group.security_group_dev-sg.id]
  tags                   = var.instance2-tag
}

output "instance-public-name-01" {
  value = (trimsuffix(aws_instance.instance_public_inst_1.public_dns, ".amazonaws.com"))
}
