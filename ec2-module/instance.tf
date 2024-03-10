terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Use the module for VPC creation
module "my_vpc" {
  source             = "./vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = var.availability_zones
}

# Use the module for security group creation
module "my_security_group" {
  source           = "./security_group"
  security_group_name = "my-security-group"
  vpc_id              = module.my_vpc.vpc_id
  allowed_ports       = [22, 80, 443]
}

# Use the module for key pair creation
module "my_keypair" {
  source   = "./keypair"
  key_name = "tf-key-pair"
}

# Use the module for EBS volume creation
module "my_ebs" {
  source             = "./ebs"
  az_count           = length(var.availability_zones)
  availability_zones = var.availability_zones
  ebs_size           = 20
  instance_count     = var.instance_count
}

# Launch an EC2 instance
resource "aws_instance" "Test-EC2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.subnet_ids[count.index % length(module.my_vpc.subnet_ids)]  # Fix to access subnet_ids output
  count                       = var.instance_count
  vpc_security_group_ids      = [module.my_security_group.security_group_id]  # Fix to access security_group_id output
  key_name                    = module.my_keypair.key_name  # Fix to access key_name output
  associate_public_ip_address = true
  tags = {
    "Name"        = "WEB-Server-${count.index + 1}"
    "Launched-By" = "Terraform-CLI"
    "Team"        = "DevOps"
  }
}

# Attach EBS Volumes to EC2 Instances
resource "aws_volume_attachment" "ebs_attachment" {
  count       = var.instance_count
  device_name = "/dev/sdh"

  volume_id   = module.my_ebs.volume_ids[count.index]  # Fix to access volume_ids output
  instance_id = aws_instance.Test-EC2[count.index].id
}
