variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "cloudzenia"
}

variable "domain_name" {
  type = string
  description = "Root domain to use, e.g. helloworld.com"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "db_username" {
  type = string
  default = "wpadmin"
}

variable "db_allocated_storage" {
  type = number
  default = 20
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_pair_name" {
  type = string
  description = "Existing key pair name for SSH"
}
