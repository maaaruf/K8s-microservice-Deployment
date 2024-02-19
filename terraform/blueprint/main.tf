module "network" {
  source   = "../modules/network"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  subnet_configs = [
    {
      subnet_name = var.public_subnet_name,
      subnet_cidr = var.public_subnet_cidr,
      is_public   = true
    },
    {
      subnet_name = var.private_subnet_name,
      subnet_cidr = var.private_subnet_cidr,
      is_public   = false
    }
  ]
  gw_tags  = var.gw_tags
  gw_cidr  = var.gw_cidr
  sg_ports = [6443, 8472, 10250, 51820, 51821, 22, 80, 443]
  sg_ports_range = [
    {
      from_port = 2379
      to_port   = 2380
    },
    {
      from_port = 30000
      to_port   = 32767
    }
  ]
}


module "ec2" {
  source                = "../modules/ec2"
  public_subnet_id      = module.network.public_subnet_id
  private_subnet_id     = module.network.private_subnet_id
  security_group_id     = module.network.security_group_id
  depends_on            = [module.network]
  number_of_public_vm   = var.number_of_public_vm
  number_of_private_vm  = var.number_of_private_vm
  instance_type_public  = var.instance_type_public
  instance_type_private = var.instance_type_private
  ami                   = var.ami
}


