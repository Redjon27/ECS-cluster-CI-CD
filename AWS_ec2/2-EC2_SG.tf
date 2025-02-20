#######################################################################################
# securitygroup for EC2
#######################################################################################

resource "aws_security_group" "AWS_SG2" {
  name        = "aws Ec2 security group"
  description = "aws EC2 security group"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Outbound rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] # ipv4
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "AWS_EC2_SG2"
  }

} 