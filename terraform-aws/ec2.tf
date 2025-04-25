#key pair for login

resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & S.G.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-automate-sg"
  description = "this is terraform generated S.G"
  vpc_id      = aws_default_vpc.default.id # interpolation

  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app"
  }


  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound access open"
  }

  tags = {
    Name = "automate-sg"
  }
}

# ec2 instance

resource "aws_instance" "my_instance" {
  for_each = tomap({
    terraform-micro  = "t2.micro"
    terraform-micro-two = "t2.micro"
    # terraform-micro-three = "t2.micro"
  }) # meta argument
  # count = 2    # meta argument

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]

  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id # Ubuntu
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prod" ? 10 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
    Environment = var.env
  }
}

