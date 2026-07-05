# Production Environment Configuration
# Use this for production deployments

aws_region = "ap-south-2"

# EC2 Configuration - Production uses more powerful instance
instance_type   = "t3.small"  # Better performance
ami_id          = "ami-04e44fc07a0954cc9"  # Amazon Linux 2023 ap-south-2
instance_name   = "my-terraform-ec2-prod"
key_pair_name   = "vskey"

# Security Group Configuration - Production restricts SSH access
security_group_name = "allow-ssh-prod"
ssh_port            = 22
allowed_ssh_cidr    = "YOUR_IP/32"  # CHANGE THIS TO YOUR IP - restrict SSH in production
