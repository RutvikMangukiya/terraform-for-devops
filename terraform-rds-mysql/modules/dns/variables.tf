variable "primary_cluster_endpoint" {
  description = "Primary RDS cluster endpoint"
  type        = string
}

variable "replica_cluster_endpoint" {
  description = "Replica RDS cluster endpoint"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}