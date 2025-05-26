terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#----------------------------------------------------------------------
module "rds" {
  source = "./modules/rds"

  cluster_identifier = var.cluster_identifier
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  db_name            = var.db_name

  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  deletion_protection     = var.deletion_protection
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}

module "monitoring" {
  source = "./modules/monitoring"

  cluster_identifier = module.rds.cluster_identifier
  sns_topic_arn      = aws_sns_topic.rds_alerts.arn
}

module "backups" {
  source = "./modules/backups"

  cluster_identifier = module.rds.cluster_identifier
  backup_bucket_name = var.backup_bucket_name
}

module "dns" {
  source = "./modules/dns"

  primary_cluster_endpoint = module.rds.cluster_endpoint
  replica_cluster_endpoint = module.rds.cluster_reader_endpoint
  domain_name              = var.domain_name
  hosted_zone_id           = var.hosted_zone_id
}

module "autoscaling" {
  source                        = "./modules/autoscaling"
  replica_identifier            = module.rds.reader_instance_id                                       # Target the reader
  business_hours_instance_class = "db.r5.large"                                            # Scale up during day
  off_hours_instance_class      = "db.r5.small"                                            # Scale down at night
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for RDS MySQL cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_identifier}-sg"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_sns_topic" "rds_alerts" {
  name = "${var.cluster_identifier}-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.rds_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}