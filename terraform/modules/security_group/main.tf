resource "aws_security_group" "k3s-sg" {
  name_prefix = "k3s-sg"
  vpc_id      = var.vpc-id
  description = "k3s security group"
}

resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  from_port         = 2379
  to_port           = 2380
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  from_port         = 8472
  to_port           = 8472
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule4" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule5" {
  type              = "ingress"
  from_port         = 51820
  to_port           = 51820
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule6" {
  type              = "ingress"
  from_port         = 51821
  to_port           = 51821
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule7" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule8" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}

resource "aws_security_group_rule" "rule9" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k3s-sg.id
}
