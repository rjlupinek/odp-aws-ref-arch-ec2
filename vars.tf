variable "aws_region" {
  default = "us-east-1"
}

variable "instance_subnet_1_id" {
  description = "subnet 1 id"
}

variable "instance_subnet_2_id" {
  description = "subnet 2 id"
}

variable "lb_subnet_1_id" {
  description = "subnet 1 id for the load balancer"
}

variable "lb_subnet_2_id" {
  description = "subnet 2 id for the load balancer"
}

variable "vpc_id" {
    description = "vpc id"
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "instance_1_name" {
  default = "odp-ra-instance-1"
}

variable "instance_2_name" {
  default = "odp-ra-instance-2"
}

variable "instance_subnet_1_cidr" {
  description = "cidr block for first private subnet"
}

variable "instance_subnet_2_cidr" {
  description = "cidr block for second private subnet"
}

variable "vpc_cidr" {
  description = "cidr block vpc"
}

variable "jump_host_cidr_list" {
  description = "List of cidr blocks allowed to ssh into jump server"
}

variable "jump_server_subnet_id" {
  description = "subnet id to place jump server in"
}

variable "jump_server_name" {
  default = "jump-server"
}

variable "aws_key_name" {
  description = "aws ec2 key name used to authenticate onto jump server"
}

variable "tag_for_ami_name_jump" {
  default = ["Packer-Jump"]
}

variable "tag_for_ami_name_private" {
  default = ["Packer-Private"]
}

variable "lb_cidr_block_list" {
  description = "List of CIDR blocks that have access to the load balancer"
}


