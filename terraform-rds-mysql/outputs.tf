output "cluster_endpoint" {
  description = "RDS cluster endpoint"
  value       = module.rds.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "RDS cluster reader endpoint"
  value       = module.rds.cluster_reader_endpoint
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = aws_sns_topic.rds_alerts.arn
}

output "backup_bucket_name" {
  description = "S3 bucket name for backups"
  value       = module.backups.backup_bucket_name
}

output "dns_name" {
  description = "Route53 DNS name"
  value       = module.dns.dns_name
}

output "cpu_alarm_arn" {
  description = "ARN of the CPU utilization alarm"
  value       = module.monitoring.cpu_alarm_arn
}

output "storage_alarm_arn" {
  description = "ARN of the storage space alarm"
  value       = module.monitoring.storage_alarm_arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.monitoring.log_group_name
}

output "export_task_arn" {
  description = "ARN of the RDS export task"
  value       = module.backups.export_task_arn
}

output "health_check_id" {
  description = "ID of the Route53 health check"
  value       = module.dns.health_check_id
}
