data "archive_file" "lambda_zip" {
  type = "zip"

  source_file  = "${path.module}/../lambda/s3_eventbridge_lambda.py" 
  output_path = "${path.module}/../s3_eventbridge_lambda.zip"
}

resource "aws_lambda_function" "s3_eventbridge_lambda" {
  function_name = "s3_eventbridge_lambda" 
  role          = aws_iam_role.s3_eventbridge_role.arn
  handler       = "s3_eventbridge_lambda.lambda_handler"
  architectures = ["arm64"]
  runtime       = "python3.10"
  filename      = data.archive_file.lambda_zip.output_path
  memory_size   = 256
  publish       = true
  tracing_config {
    mode = "Active"
  }
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  depends_on    = [aws_iam_role.s3_eventbridge_role]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.s3_eventbridge_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "s3_eventbridge_permission" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_eventbridge_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_event_rule.arn
}