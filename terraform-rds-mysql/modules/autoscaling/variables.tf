variable "replica_identifier" {
  description = "Identifier of the RDS read replica to scale"
  type        = string
  default     = "my-mysql-cluster-instance-1"
}

variable "business_hours_instance_class" {
  description = "Instance class during business hours (e.g., db.t3.medium)"
  type        = string
  default     = "db.t3.medium"
}

variable "off_hours_instance_class" {
  description = "Instance class during off-hours (e.g., db.t3.small) or 'stop' to pause"
  type        = string
  default     = "db.t3.small"
}

variable "aws_region_name" {
  description = "AWS region where the RDS cluster is deployed"
  type        = string
  default     = "ap-northeast-1"
}

variable "down_instance_class" {
  description = "Instance class to scale down to during off-hours"
  type        = string
  default     = "db.t3.micro"
}