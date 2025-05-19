# Primary KMS Key (East Region)

resource "aws_kms_key" "primary_key" {
  description         = "Primary KMS key for Aurora"
  enable_key_rotation = true
}

resource "aws_kms_alias" "primary_key_alias" {
  name          = "alias/primary_key"
  target_key_id = aws_kms_key.primary_key.key_id
}

# Secondary KMS Key (West Region for Replica)

resource "aws_kms_key" "secondary_key" {
  provider            = aws.backup
  description         = "Secondary KMS key for Aurora Replica"
  enable_key_rotation = true
}

resource "aws_kms_alias" "secondary_key_alias" {
  provider      = aws.backup
  name          = "alias/secondary_key"
  target_key_id = aws_kms_key.secondary_key.key_id
}

# # Primary KMS Key (East Region)
# data "aws_kms_key" "by_alias_east" {
#   key_id = "alias/primary_key"
# }

# # Secondary KMS Key (West Region for Replica)
# data "aws_kms_key" "by_alias_west" {
#   key_id   = "alias/secondary_key"
#   provider = aws.backup
# }

# Database 
resource "aws_rds_global_cluster" "global_aurora" {
  global_cluster_identifier = "global-aurora"
  engine                    = "aurora-mysql"
  engine_version            = var.db_engine_version
  database_name             = "example_db"
  storage_encrypted         = true
}

resource "aws_rds_cluster" "aurora-cluster" {
  database_name                = var.db_name
  cluster_identifier           = "aurora-primary-cluster"
  engine                       = aws_rds_global_cluster.global_aurora.engine
  engine_version               = aws_rds_global_cluster.global_aurora.engine_version
  master_username              = var.db_username
  master_password              = var.db_password
  skip_final_snapshot          = true
  backup_retention_period      = 7
  preferred_maintenance_window = "sat:13:00-sat:13:30"
  preferred_backup_window      = "14:00-14:30"
  db_subnet_group_name         = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids       = [aws_security_group.database_sg.id]
  global_cluster_identifier    = aws_rds_global_cluster.global_aurora.id
  kms_key_id                   = aws_kms_alias.primary_key_alias.arn

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "production"
  }

}

# DB subnet group for RDS 
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

resource "aws_rds_cluster_instance" "primary" {
  identifier           = "aurora-instance"
  cluster_identifier   = aws_rds_cluster.aurora-cluster.cluster_identifier
  engine               = aws_rds_cluster.aurora-cluster.engine
  instance_class       = var.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}


############
# Recovery #
############
#  Database - recovery

resource "aws_rds_cluster" "recovery-aurora-cluster" {
  provider                       = aws.backup
  cluster_identifier             = "aurora-secondary-cluster"
  engine                         = aws_rds_global_cluster.global_aurora.engine
  engine_version                 = aws_rds_global_cluster.global_aurora.engine_version
  skip_final_snapshot            = true
  backup_retention_period        = 7
  preferred_maintenance_window   = "sat:13:00-sat:13:30" //UTC Time
  db_subnet_group_name           = aws_db_subnet_group.recovery_db_subnet_group.name
  vpc_security_group_ids         = [aws_security_group.recovery_database_sg.id]
  global_cluster_identifier      = aws_rds_global_cluster.global_aurora.id
  replication_source_identifier  = aws_rds_cluster.aurora-cluster.arn
  enable_global_write_forwarding = true
  kms_key_id                     = aws_kms_alias.secondary_key_alias.arn

  lifecycle {
    create_before_destroy = true
  }

}

# DB subnet group for RDS 
resource "aws_db_subnet_group" "recovery_db_subnet_group" {
  provider   = aws.backup
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.recovery_public_subnet3.id, aws_subnet.recovery_public_subnet4.id]
}

resource "aws_rds_cluster_instance" "recovery-aurora-instance" {
  provider             = aws.backup
  identifier           = "recovery-aurora-instance"
  cluster_identifier   = aws_rds_cluster.recovery-aurora-cluster.cluster_identifier
  engine               = aws_rds_cluster.recovery-aurora-cluster.engine
  instance_class       = var.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}