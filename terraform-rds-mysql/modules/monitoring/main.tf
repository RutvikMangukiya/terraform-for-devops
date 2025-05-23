resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "${var.cluster_identifier}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name          = "${var.cluster_identifier}-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000000000" # 10GB
  alarm_description   = "Database storage space is running low"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
  }
}

# Writer instance changes (failovers)
resource "aws_cloudwatch_metric_alarm" "writer_change" {
  alarm_name          = "${var.cluster_identifier}-writer-change"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"
  evaluation_periods  = "1"
  period              = "60"
  alarm_description   = "Triggered when primary writer instance changes"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
  }
}

resource "aws_cloudwatch_log_group" "rds_logs" {
  name              = "/aws/rds/cluster/${var.cluster_identifier}/mysql"
  retention_in_days = 30
}