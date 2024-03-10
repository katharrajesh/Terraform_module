variable "security_group_name" {
  description = "Name for the security group"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
}
