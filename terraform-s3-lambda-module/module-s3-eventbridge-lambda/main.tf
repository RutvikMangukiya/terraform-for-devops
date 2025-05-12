# S3 bucket------------------------------------------------------------------------
resource "aws_s3_bucket" "s3_trigger_eventbridge" {
  bucket = var.bucket_name
    tags = {
    Name = "Eventbridge S3 Bucket"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_trigger_eventbridge.id
  eventbridge = true
}

# IAM role------------------------------------------------------------------------
resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_name}_exec_role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.lambda_name}_policy_lambda"
  description = "IAM policy for Lambda to access CloudWatch and S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Describe*",
        "s3-object-lambda:Get*",
        "s3-object-lambda:List*"
      ],
      "Resource": "arn:aws:s3:::s3-eventbridge-test-rutvik/*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Lambda Function------------------------------------------------------------------------

data "archive_file" "lambda_zip" {
  type        = "zip"

  source_file = "${path.module}/lambda-code/lambda.py"

  output_path = "${path.module}/lambda.zip"
}


resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_name
  architectures    = var.architectures
  description      = var.description
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  role             = aws_iam_role.lambda_exec.arn
  filename         = var.lambda_zip_path
  memory_size      = var.memory_size
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  depends_on       = [aws_iam_role.lambda_exec]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_put_rule.arn
}

# Eventbridge------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "s3_put_rule" {
  name        = "${var.bucket_name}_object_created_rule"
  description = "Trigger Lambda on S3 object creation"
  event_pattern = jsonencode({
    source = ["aws.s3"],
    detail-type = ["Object Created"],
    detail = {
      bucket = {
        name = [var.bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_event_target" {
  rule = aws_cloudwatch_event_rule.s3_put_rule.name
  target_id = "s3_event_target"
  arn       = aws_lambda_function.lambda.arn
}