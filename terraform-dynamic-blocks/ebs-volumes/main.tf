provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "example" {
    ami = "ami-0d866da98d63e2b42"      # Give valid AMI
    instance_type = "t2.micro"

    dynamic "ebs_block_device" {
        for_each = var.ebs_volumes
        content {
          device_name = ebs_block_device.value.device_name
          volume_size = ebs_block_device.value.volume_size
        }
    }

    tags = {
      Name = "Dynamic EBS Example"
    }
}