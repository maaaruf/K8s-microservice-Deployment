output "vpc-id" {
  value = aws_vpc.poridhi_vpc.id
}
# 
# output "public_subnet_id" {
#   value = aws_subnet.poridhi_subnet_public.id
# }
# 
# output "private_subnet_id" {
#   value = aws_subnet.poridhi_subnet_private.id
# }

output "public_subnet_id" {
  value = local.public_subnet_ids[0]
}

output "private_subnet_id" {
  value = local.private_subnet_ids[0]
}

output "security_group_id" {
  value = aws_security_group.k3s-sg.id
}