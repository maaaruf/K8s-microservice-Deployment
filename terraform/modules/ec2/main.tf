resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example" {
  key_name   = "k3s-key-pair"
  public_key = tls_private_key.example.public_key_openssh
}

# resource "local_file" "k3s-key" {
#   content  = tls_private_key.example.private_key_pem
#   filename = "k3s-key.pem"
# }

resource "aws_s3_object" "object" {
  bucket = "poridhi-briefly-curiously-rightly-greatly-infinite-lion"
  key    = "k3s-key.pem"
  content = tls_private_key.example.private_key_pem
}

resource "aws_instance" "public" {
  ami           = var.ami
  instance_type = var.instance_type_public
  count         = var.number_of_public_vm
  subnet_id     = var.public_subnet_id
  key_name      = "k3s-key-pair"
  security_groups = [
    var.security_group_id,
  ]
  # depends_on = [aws_key_pair.example, tls_private_key.example, local_file.k3s-key]
  depends_on = [aws_key_pair.example, tls_private_key.example, aws_s3_object.object]
}

resource "aws_eip" "public" {
  count  = var.number_of_public_vm
  domain = "vpc"
}

resource "aws_eip_association" "public" {
  count         = var.number_of_public_vm
  instance_id   = aws_instance.public.*.id[count.index]
  allocation_id = aws_eip.public.*.id[count.index]
}

resource "aws_instance" "private" {
  ami           = var.ami
  instance_type = var.instance_type_private
  count         = var.number_of_private_vm
  subnet_id     = var.private_subnet_id
  key_name      = "k3s-key-pair"
  security_groups = [
    var.security_group_id,
  ]
  # depends_on = [aws_key_pair.example, tls_private_key.example, local_file.k3s-key]
  depends_on = [aws_key_pair.example, tls_private_key.example, aws_s3_object.object]
}

## Provisioning k3s master node
#resource "null_resource" "k3s_master" {
#  depends_on = [aws_instance.private]
#
#  provisioner "remote-exec" {
#    inline = [
#      "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - server",
#      "sudo cat /etc/rancher/k3s/k3s.yaml > /tmp/k3s-config.yaml",
#    ]
#
#    connection {
#      type        = "ssh"
#      host        = aws_instance.private[0].public_ip
#      user        = "ec2-user"
#      private_key = tls_private_key.example.private_key_pem
#    }
#  }
#
#  provisioner "local-exec" {
#    command = "scp -o StrictHostKeyChecking=no -i ${local_file.k3s-key.filename} ec2-user@${aws_instance.private[0].public_ip}:/tmp/k3s-config.yaml ."
#  }
#}
#
## Extracting master token
#data "local_file" "master_token" {
#  depends_on = [null_resource.k3s_master]
#
#  content  = <<-EOF
#    locals {
#      master_token = "$(grep 'token:' k3s-config.yaml | awk '{print $2}')"
#    }
#  EOF
#
#  filename = "master_token.tf"
#}
#
## Provisioning k3s worker nodes
#resource "null_resource" "k3s_worker" {
#  depends_on = [aws_instance.private, data.local_file.master_token]
#
#  count = 2
#
#  provisioner "remote-exec" {
#    inline = [
#      "curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.private[0].private_ip}:6443 K3S_TOKEN=${data.local_file.master_token.locals.master_token} sh -",
#    ]
#
#    connection {
#      type        = "ssh"
#      host        = aws_instance.private[count.index + 1].public_ip
#      user        = "ec2-user"
#      private_key = tls_private_key.example.private_key_pem
#    }
#  }
#}
