locals {
  subnet_tags = {
    for subnet in var.subnet_configs :
    subnet.subnet_name => {
      Name = subnet.subnet_name
    }
  }
  subnet_cidrs = {
    for subnet in var.subnet_configs :
    subnet.subnet_name => subnet.subnet_cidr
  }
  subnet_public = {
    for subnet in var.subnet_configs :
    subnet.subnet_name => subnet.is_public
  }
}

resource "aws_vpc" "poridhi_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "poridhi_subnet" {
  for_each = { for idx, subnet in var.subnet_configs : idx => subnet }
  # count = length(var.subnet_configs)
  vpc_id = aws_vpc.poridhi_vpc.id
  # cidr_block = var.subnet_configs[count.index].subnet_cidr
  cidr_block              = local.subnet_cidrs[each.value.subnet_name]
  map_public_ip_on_launch = local.subnet_public[each.value.subnet_name]

  # tags = {
  #     Name = var.subnet_configs[count.index].subnet_name
  # }
  tags = local.subnet_tags[each.value.subnet_name]
}

# resource "aws_subnet" "poridhi_subnet_private" {
#     vpc_id     = aws_vpc.poridhi_vpc.id
#     cidr_block = "10.10.2.0/24"
# 
#     tags = {
#         Name = "poridhi"
#     }
# }


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.poridhi_vpc.id

  tags = {
    Name = var.gw_tags
  }
}

# resource "aws_internet_gateway_attachment" "gw_attachment" {
#     internet_gateway_id = aws_internet_gateway.gw.id
#     vpc_id              = aws_vpc.poridhi_vpc.id
# }

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.poridhi_vpc.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.poridhi_vpc.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.gw_cidr
  gateway_id             = aws_internet_gateway.gw.id
}


/* Route table associations */
resource "aws_route_table_association" "rt_association" {
  for_each       = aws_subnet.poridhi_subnet
  subnet_id      = each.value.id
  route_table_id = each.value.map_public_ip_on_launch ? aws_route_table.public_rt.id : aws_route_table.private_rt.id
}


resource "aws_main_route_table_association" "public_rt" {
  vpc_id         = aws_vpc.poridhi_vpc.id
  route_table_id = aws_route_table.public_rt.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

locals {
  public_subnet_ids = [
    for subnet in aws_subnet.poridhi_subnet :
    subnet.id
    if subnet.map_public_ip_on_launch
  ]

  private_subnet_ids = [
    for subnet in aws_subnet.poridhi_subnet :
    subnet.id
    if !subnet.map_public_ip_on_launch
  ]
}

# Create NAT Gateway for private vm
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# add route for nat gateway
resource "aws_route" "nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.gw_cidr
  nat_gateway_id         = aws_nat_gateway.example.id
}

# create security group rules for k3s
resource "aws_security_group" "k3s-sg" {
  name_prefix = "k3s-sg"
  vpc_id      = aws_vpc.poridhi_vpc.id
  description = "k3s security group"
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = {
    for port in var.sg_ports :
    port => port
  }
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "ingress_rules2" {
  for_each = {
    for port in var.sg_ports_range :
    "${port.from_port}-${port.to_port}" => port
  }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}