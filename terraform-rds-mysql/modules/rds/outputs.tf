output "cluster_identifier" {
  value = aws_rds_cluster.mysql_cluster.cluster_identifier
}

output "cluster_endpoint" {
  value = aws_rds_cluster.mysql_cluster.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.mysql_cluster.reader_endpoint
}