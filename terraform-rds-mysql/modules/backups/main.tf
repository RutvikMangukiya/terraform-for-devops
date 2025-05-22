resource "aws_s3_bucket" "backup_bucket" {
  bucket = var.backup_bucket_name
#   region = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "rds_snapshot_export_role" {
  name = "rds-snapshot-export-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "export.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_snapshot_export_policy" {
  name = "rds-snapshot-export-policy"
  role = aws_iam_role.rds_snapshot_export_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject*",
          "s3:ListBucket",
          "s3:GetObject*",
          "s3:DeleteObject*",
          "s3:GetBucketLocation"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.backup_bucket.arn,
          "${aws_s3_bucket.backup_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_db_cluster_snapshot" "manual_snapshot" {
  db_cluster_identifier          = var.cluster_identifier
  db_cluster_snapshot_identifier = "${var.cluster_identifier}-manual-snapshot"
}

# KMS key resource ------------------------------------------------------------------------------------

# Add this data source to get current AWS account ID
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "rds_export_key" {
  description             = "KMS key for RDS snapshot exports"
  deletion_window_in_days = 10  # Minimum 7 days for KMS key deletion
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json  # Attach policy (see below)
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    actions = [
      "kms:*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}

resource "aws_rds_export_task" "snapshot_export" {
  export_task_identifier = "${var.cluster_identifier}-export"
  source_arn            = aws_db_cluster_snapshot.manual_snapshot.db_cluster_snapshot_arn
  s3_bucket_name        = aws_s3_bucket.backup_bucket.id
  iam_role_arn          = aws_iam_role.rds_snapshot_export_role.arn
  kms_key_id             = aws_kms_key.rds_export_key.arn  # Using new kms key
}