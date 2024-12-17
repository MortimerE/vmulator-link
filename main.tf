# Specify the provider
provider "aws" {
  region = "us-east-1"  # Adjust as needed
}

# Define the VM instance
resource "aws_instance" "vba_m_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example for Ubuntu 20.04 LTS in us-east-1
  instance_type = "t3.medium"              # 2 vCPUs, 4 GB RAM

  # Configure SSH key pair for access
  key_name = "your_key_pair_name"          # Ensure this key pair exists in your AWS account

  # Security group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.vba_m_sg.id]

  # User data to install Ansible (optional)
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y ansible
              EOF

  tags = {
    Name = "VBA-M-Server"
  }
}

# Security group definition
resource "aws_security_group" "vba_m_sg" {
  name        = "vba_m_sg"
  description = "Allow SSH and HTTP"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
