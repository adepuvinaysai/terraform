variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023 ap-south-2)"
  type        = string
  default     = "ami-04e44fc07a0954cc9"
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair (must exist in AWS Console)"
  type        = string
  default     = "vskey"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "my-terraform-ec2"
}

variable "ssh_port" {
  description = "SSH port for security group"
  type        = number
  default     = 22
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access (0.0.0.0/0 allows all, restrict to your IP)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "allow-ssh"
}
