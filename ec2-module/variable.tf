variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  }

variable "instance_count" {
  type    = number
  default = 3
}  

variable "my-provider" {
  type = string
  default = "ap-south-1"
}

variable "ami_id" {
  type = string
  default = "ami-03f4878755434977f"
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}