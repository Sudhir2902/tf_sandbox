variable "cidr_block" {
    type = string
    default = ""
    description = "(optional) describe your variable"
}
variable "instance_tenancy" {
    type = string
    description = "define instance tenancy of VPC"
}

variable "enable_dns_support" {
    type = bool
    description = "Define dns support is enabled"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "define dns hostnameis enabled"
  
}

variable "vpc-tags" {
    type = map(string)
}

variable "subnet1_cidr_block" {
    type = string
    description = "define cidr for 1st subnet"
}

variable "map_public_ip_on_launch" {
    type = bool
    description = "define if public ip is map on launch"
}

variable "subnet1-AZ" {
    type = string
    description = "Define AZ of Sunbnet 1"
}

variable "subnet1-tags" {
    type = map(string)
    description = "Define tag for subnet 1"
}

variable "subnet2_cidr_block" {
    type = string
    description = "define cidr for 2nd subnet"
  
}

variable "subnet2-AZ" {
    type = string
    description = "Define AZ of Sunbnet 1"
}

variable "subnet2-tags" {
    type = map(string)
    description = "Define tag for subnet 1"
}

variable "IG_cidr_block" {
    type = string
}

variable "IG-tags" {
    type = map(string)
    description = "Define tag for IG"
}

variable "sg-tags" {
    type = map(string)
    description = "Define tag for SG"
}

variable "security_group_dev-sg-name" {
    type = string
    description = "Define name of sg"
}

variable "instance_ami" {
    type = string
    description = "Decfine ami id of instance"
}

variable "instance_type" {
    type = string
    description = "Define type of instance" 
}

variable "instance-tags" {
  type = map(string)
}

variable "instance2-tag" {
  type = map(string)
}