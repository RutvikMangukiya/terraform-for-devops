resource "aws_cloudwatch_event_rule" "s3_event_rule" {
  name          = "s3_event_rule"
  description   = "Trigger Lambda from S3 events"
  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail-type = ["Object Created"],
    detail = {
      bucket = {
        name = ["${aws_s3_bucket.s3_trigger_eventbridge.bucket}"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_event_target" {
  rule      = aws_cloudwatch_event_rule.s3_event_rule.name
  target_id = "s3_event_target"
  arn       = aws_lambda_function.s3_eventbridge_lambda.arn
}