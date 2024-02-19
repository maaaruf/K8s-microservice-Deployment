variable "public_subnet_id" {
  description = "Public Subnet ID"
}

variable "private_subnet_id" {
  description = "Private Subnet ID"
}

variable "security_group_id" {
  description = "Security Group ID"
}

variable "number_of_public_vm" {}

variable "number_of_private_vm" {}

variable "instance_type_public" {}

variable "instance_type_private" {}

variable "ami" {}