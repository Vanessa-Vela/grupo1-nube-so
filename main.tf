# Grupo 1 - Nube y Linux minimal
# Crea una instancia Ubuntu 24.04 (t3.micro) con nginx y hardening basico.
# Uso: terraform init -> terraform plan -> terraform apply -> terraform destroy

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web" {
  name = "grupo1-tf"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOT
    #!/bin/bash
    printf "PermitRootLogin no\nPasswordAuthentication no\n" > /etc/ssh/sshd_config.d/00-hardening.conf
    systemctl restart ssh
    apt-get update -y && apt-get install -y nginx fail2ban
    echo "<h1>Grupo 1 - desplegado con Terraform</h1>" > /var/www/html/index.html
  EOT

  tags = {
    Name = "grupo1-terraform"
  }
}

output "ip_publica" {
  value = aws_instance.web.public_ip
}
