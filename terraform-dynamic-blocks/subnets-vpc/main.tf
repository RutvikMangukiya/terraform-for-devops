provider "aws" {
  region = "sa-east-1"
}

resource "aws_vpc" "name" {
    cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "subnets" {
    for_each = { for subnet in var.subnets : subnet.name => subnet }

    vpc_id = aws_vpc.name.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
}