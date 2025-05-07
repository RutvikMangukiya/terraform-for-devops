#This is S3 bucket !

resource "aws_s3_bucket" "remote_s3" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    Name        = "terraform-infra-bucket-rutvik"
    Environment = var.env
  }
}