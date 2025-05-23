variable "cluster_identifier" {
  description = "RDS cluster identifier"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  type        = string
}