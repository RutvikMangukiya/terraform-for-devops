variable "cluster_identifier" {
  description = "RDS cluster identifier"
  type        = string
}

variable "backup_bucket_name" {
  description = "S3 bucket name for backup exports"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"    
}