resource "aws_s3_bucket" "remote_s3" {
  bucket = "terraform-state-bucket-rut"

  tags = {
    Name        = "terraform-state-bucket-rutvik"
  }
}