# VPC

resource "aws_vpc" "my_site_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "primary"
  }
}

# Define public subnet----------------------------------------

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.my_site_vpc.id
  cidr_block        = "10.123.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "primary-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.my_site_vpc.id
  cidr_block        = "10.123.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "primary-public-subnet-2"
  }
}

# Internet Gateway----------------------------------------

resource "aws_internet_gateway" "rut_internet_gateway" {
  vpc_id = aws_vpc.my_site_vpc.id
  depends_on = [ aws_vpc.my_site_vpc ]

  tags = {
    Name = "primary-igw"
  }
}

# Route table--------------------------------------------

resource "aws_route_table" "primary_public_rt" {
  vpc_id = aws_vpc.my_site_vpc.id

  tags = {
    Name = "primary_public_rt"
  }
}

# Route-----------------------------------------------------------------------

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.primary_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rut_internet_gateway.id
}

# RT Association--------------------------------------------------------------

resource "aws_route_table_association" "public_subnet1_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.primary_public_rt.id
}

resource "aws_route_table_association" "public_subnet2_assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.primary_public_rt.id
}

# Security group DB-----------------------------------------------------------

resource "aws_security_group" "database_sg" {
  name        = "primary-database-sg"
  description = "primary database security group"
  vpc_id      = aws_vpc.my_site_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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