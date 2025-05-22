output "backup_bucket_name" {
  description = "Name of the S3 backup bucket"
  value       = aws_s3_bucket.backup_bucket.id
}

output "export_task_arn" {
  description = "ARN of the RDS export task"
  value       = aws_rds_export_task.snapshot_export.id
}

output "export_kms_key_arn" {
  value = aws_kms_key.rds_export_key.arn
}