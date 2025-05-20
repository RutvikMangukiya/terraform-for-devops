# VPC

resource "aws_vpc" "recovery_site_vpc" {
  cidr_block           = "10.0.0.0/16"
  provider             = aws.backup
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "secondary"
  }
}

# Define public subnet----------------------------------------

resource "aws_subnet" "recovery_public_subnet3" {
  vpc_id            = aws_vpc.recovery_site_vpc.id
  provider          = aws.backup
  cidr_block        = "10.0.2.0/25"
  availability_zone = "us-west-1b"

  tags = {
    Name = "secondary-public-subnet-3"
  }
}

resource "aws_subnet" "recovery_public_subnet4" {
  vpc_id            = aws_vpc.recovery_site_vpc.id
  provider          = aws.backup
  cidr_block        = "10.0.1.0/25"
  availability_zone = "us-west-1c"

  tags = {
    Name = "secondary-public-subnet-4"
  }
}

# Internet Gateway----------------------------------------

resource "aws_internet_gateway" "secondary_internet_gateway" {
  vpc_id = aws_vpc.recovery_site_vpc.id
  depends_on = [ aws_vpc.recovery_site_vpc ]

  tags = {
    Name = "secondary-igw"
  }
}

# Route table--------------------------------------------

resource "aws_route_table" "secondary_public_rt" {
  vpc_id   = aws_vpc.recovery_site_vpc.id
  provider = aws.backup

  tags = {
    Name = "secondary_public_rt"
  }
}

# Route-----------------------------------------------------------------------

resource "aws_route" "secondary_default_route" {
  route_table_id         = aws_route_table.secondary_public_rt.id
  provider               = aws.backup
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.secondary_internet_gateway.id
}

# RT Association--------------------------------------------------------------

resource "aws_route_table_association" "public_subnet3_assoc" {
  subnet_id      = aws_subnet.recovery_public_subnet3.id
  route_table_id = aws_route_table.secondary_public_rt.id
  provider       = aws.backup
}

resource "aws_route_table_association" "public_subnet4_assoc" {
  subnet_id      = aws_subnet.recovery_public_subnet4.id
  route_table_id = aws_route_table.secondary_public_rt.id
  provider       = aws.backup
}

# Security group DB----------------------------------------------------------- 

resource "aws_security_group" "recovery_database_sg" {
  name        = "secondary-database-sg"
  description = "secondary database security group"
  vpc_id      = aws_vpc.recovery_site_vpc.id
  provider    = aws.backup

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