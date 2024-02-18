# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

terraform {
  cloud {
    organization = "terraform-mehedi"

    workspaces {
      name = "github_actions"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "dev_infra" {
  source                = "./blueprint"
  vpc_cidr              = "10.10.0.0/16"
  vpc_name              = "dev-vpc"
  public_subnet_name    = "dev-public-subnet"
  public_subnet_cidr    = "10.10.1.0/24"
  private_subnet_name   = "dev-private-subnet"
  private_subnet_cidr   = "10.10.2.0/24"
  instance_type_private = "t2.medium"
  instance_type_public  = "t2.micro"
  number_of_private_vm  = 3
  number_of_public_vm   = 2
  gw_cidr               = "0.0.0.0/0"
  gw_tags               = "poridhi"
  ami                   = "ami-0c7217cdde317cfec"
}