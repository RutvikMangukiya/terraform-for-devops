output "dns_name" {
  description = "DNS name for the RDS endpoint"
  value       = aws_route53_record.primary.name
}

output "health_check_id" {
  description = "ID of the Route53 health check"
  value       = aws_route53_health_check.primary.id
}