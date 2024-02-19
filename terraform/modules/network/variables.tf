variable "vpc_cidr" {
  type = string
}

variable "subnet_configs" {
  type = list(any)
}

variable "vpc_name" {
  type = string
}

variable "gw_tags" {
  type = string
}

variable "gw_cidr" {
  type = string
}

variable "sg_ports" {
  type = list(any)
}

variable "sg_ports_range" {
  type = list(any)
}