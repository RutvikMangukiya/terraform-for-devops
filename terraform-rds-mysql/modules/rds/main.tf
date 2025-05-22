resource "aws_rds_cluster" "mysql_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.db_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  deletion_protection     = var.deletion_protection
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name
  allow_major_version_upgrade = true
  skip_final_snapshot     = true
  storage_encrypted       = true
  enable_http_endpoint    = false
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.mysql_cluster.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.mysql_cluster.engine
  engine_version     = aws_rds_cluster.mysql_cluster.engine_version
  publicly_accessible = false
}