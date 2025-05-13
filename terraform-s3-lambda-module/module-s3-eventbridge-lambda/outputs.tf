output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.s3_trigger_eventbridge.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "event_rule_name" {
  description = "Name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.s3_put_rule.name
}

output "lambda_zip_path" {
  value = aws_lambda_function.lambda.filename
  description = "path to zip code"
}

output "module_path" {
  value = path.module
}