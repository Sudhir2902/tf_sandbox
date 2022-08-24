#################################################
###############VPC CONFIGURATIONS################
#################################################
cidr_block = "10.0.0.0/16"
instance_tenancy = "default"
enable_dns_support = true
enable_dns_hostnames = true
vpc-tags = {
  "Name" = "dev"
}

subnet1_cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
subnet1-AZ = "us-east-1a"
subnet1-tags = {
  "Name" = "dev-public-1"
}

subnet2_cidr_block = "10.0.2.0/24"
subnet2-AZ = "us-east-1b"
subnet2-tags = {
  Name = "dev-public-2"
}

IG_cidr_block = "0.0.0.0/0"
IG-tags = {
  "Name" = "dev-public-1-IG"
}

sg-tags = {
  Name = "dev-sg"
}

security_group_dev-sg-name = "dev-sg"

instance_ami = "ami-090fa75af13c156b4"
instance_type = "t2.micro"
instance-tags = {
  Name = "public_inst_1"
}
instance2-tag = {
  Name = "public_inst_2"
}