terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security group — allows SSH on port 22
resource "aws_security_group" "allow_ssh" {
  name        = var.security_group_name
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance — uses key pair created in AWS Console
resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = var.instance_name
  }
  
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket       = "vs-bucket-test-xyz"
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Outputs — prints IP and ready-to-use SSH command after apply
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.my_ec2.public_ip}"
}


