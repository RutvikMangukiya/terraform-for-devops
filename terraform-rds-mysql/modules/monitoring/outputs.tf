output "cpu_alarm_arn" {
  description = "ARN of the CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization.arn
}

output "storage_alarm_arn" {
  description = "ARN of the storage space alarm"
  value       = aws_cloudwatch_metric_alarm.free_storage_space.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.rds_logs.name
}