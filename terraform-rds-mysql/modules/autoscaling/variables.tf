variable "replica_identifier" {
  description = "Identifier of the RDS read replica to scale"
  type        = string
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