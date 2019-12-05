# Instances

This module creates three AWS instances: 
- Two private instances built from an AMI using [this](../../packer/packer-private.json) Packer file. They will host Nginx web servers and are only accesable from within the VPC. 
- One public instance built from an AMI using [this](../../packer/packer-jump.json) packer file. It is used as a jump server to access the private instances because the private servers are only accessable from within the VPC built by [this](../network) module.  

## Variables 
| Name | Description |
|--|--|
| instance_subnet_1_id | The subnet ID for the first private instance |
| instance_subnet_2_id | The subnet ID for the first second instance |
| lb_subnet_1_id | The first subnet ID to hook up to the load balancer |
| lb_subnet_2_id | The second subnet ID to hook up to the load balancer |
| vpc_id | The ID of the VPC |
| instance_subnet_1_cidr | The CIDR block of the subnet with the first private instance used to configure the load balancer security group |
| instance_subnet_2_cidr | The CIDR block of the subnet with the second private instance used to configure the load balancer security group |
| vpc_cidr | The CIDR block of the VPC |
| jump_host_cidr_list | The list of CIDR blocks to allow SSH access to the public instance |
| jump_server_subnet_id | The subnet ID to place the public instance |
| aws_key_name | The name of the AWS key pair used to authenticate into the three instances |
| tag_for_ami_name_ jump | An array of strings which represent the value to the tag `Name` for the AMI to be created for the jump server |
| tag_for_ami_name_private | An array of strings which represent the value to the tag `Name` for the AMI to be created for the private servers |
| lb_cidr_block_list | An array of CIDR blocks that are allowed access to the load balancer | 

## Further Information

To learn more about EC2 Instances click [here](https://aws.amazon.com/ec2/).
