# AWS Configuration
aws_region = "ap-south-2"

# EC2 Configuration
instance_type   = "t3.micro"
ami_id          = "ami-04e44fc07a0954cc9"  # Amazon Linux 2023 ap-south-2
instance_name   = "my-terraform-ec2"
key_pair_name   = "vskey"

# Security Group Configuration
security_group_name = "allow-ssh"
ssh_port            = 22
allowed_ssh_cidr    = "0.0.0.0/0"  # Change to your IP: "YOUR_IP/32" for security
