output "cluster_identifier" {
  value = aws_rds_cluster.mysql_cluster.cluster_identifier
}

output "cluster_endpoint" {
  value = aws_rds_cluster.mysql_cluster.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.mysql_cluster.reader_endpoint
}

# output "reader_instance_id" {
#   value = aws_rds_cluster_instance.reader.identifier
# }

output "reader_instance_id" {
  value = aws_rds_cluster_instance.cluster_instances[1].identifier # Assuming index 1 is the reader instance
}

# output "reader_instance_id" {
#   value = [
#     for instance in aws_rds_cluster_instance.cluster_instances :
#     instance.identifier
#     if instance.instance_role == "READER"
#   ][0]
# }
