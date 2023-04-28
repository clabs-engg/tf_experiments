
data "http" "public_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_security_group" "production-sg" {
  name        = "VM SG"
  description = "Allow inbound traffic for HTTP and HTTPS via IPv4 and IPv6 CIDRs"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP IPv4"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS IPv4"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP IPv6"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTPS IPv6"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Server SG"
  }
}

# Create another Security Group for EC2
resource "aws_security_group" "production-ssh-sg" {
  name        = "SSH SG"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.public_ip.body)}/32"] #Takes the Public IP of the Machine on Which TF Script is running
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH SG"
  }

}


resource "aws_instance" "ec2Host" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.ssh_key

  vpc_security_group_ids = [
    aws_security_group.production-sg.id, aws_security_group.production-ssh-sg.id
  ]

  root_block_device {
    delete_on_termination = true
    iops                  = 1000
    volume_size           = 80
    volume_type           = "gp3"
  }
  tags = {
    Name = "My Server"
  }
}

