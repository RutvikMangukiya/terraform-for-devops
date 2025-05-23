resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_cluster_endpoint
  port              = 3306
  type              = "TCP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "Primary RDS Health Check"
  }
}

resource "aws_route53_record" "primary" {
  zone_id = var.hosted_zone_id
  name    = "db.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.primary_cluster_endpoint]

  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary.id
  set_identifier  = "primary"
}

resource "aws_route53_record" "secondary" {
  zone_id = var.hosted_zone_id
  name    = "db.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.replica_cluster_endpoint]

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
}