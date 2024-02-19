variable "number_of_public_vm" {}

variable "number_of_private_vm" {}

variable "instance_type_public" {}

variable "instance_type_private" {}

variable "ami" {}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "public_subnet_cidr" {
  type        = string
  description = "public subnet cidr block"
}

variable "private_subnet_cidr" {
  type        = string
  description = "private subnet cidr block"
}

variable "public_subnet_name" {
  type        = string
  description = "public subnet name"
}

variable "private_subnet_name" {
  type        = string
  description = "private subnet name"
}

variable "gw_tags" {
  type        = string
  description = "gateway tags"
}

variable "gw_cidr" {
  type        = string
  description = "gateway cidr block"
}

