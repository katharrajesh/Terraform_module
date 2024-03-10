variable "az_count" {
  description = "Number of availability zones"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones for EBS volumes"
  type        = list(string)
}

variable "ebs_size" {
  description = "Size of the EBS volume (in GB)"
  type        = number
}

variable "instance_count" {
  description = "Number of instances to attach EBS volumes to"
  type        = number
}