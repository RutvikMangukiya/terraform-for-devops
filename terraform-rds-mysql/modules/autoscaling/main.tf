resource "null_resource" "lambda_zip" {
  triggers = {
    always_run = timestamp()  # Forces rebuild on every apply
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/lambda_pkg && 
      cp ${path.module}/lambda/rds-autoscaling.py ${path.module}/lambda_pkg/ &&
      cd ${path.module}/lambda_pkg && 
      zip -r ../lambda/rds_autoscaling.zip .
    EOF
  }
}

resource "aws_lambda_function" "rds_scaling" {
  filename      = "${path.module}/lambda/rds_autoscaling.zip"
  function_name = "rds_replica_scaling"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "rds-autoscaling.lambda_handler"
  runtime       = "python3.8"
  timeout       = 30
  # Ensure the zip is created before Lambda deployment
  depends_on = [null_resource.lambda_zip]

  environment {
    variables = {
      aws_region_name        = var.aws_region_name
      down_instance_class    = var.down_instance_class
      instance_identifier    = var.replica_identifier                   # Writer instance identifier
      up_instance_class      = var.business_hours_instance_class         # Instance class during business hours
      # REPLICA_ID             = var.replica_identifier
      # BUSINESS_HOURS_CLASS   = var.business_hours_instance_class
      # OFF_HOURS_CLASS        = var.off_hours_instance_class
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "rds_scaling_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Custom policy for Aurora cluster instance modifications
resource "aws_iam_role_policy" "lambda_rds_aurora" {
  name = "lambda_rds_aurora_policy"
  role = aws_iam_role.lambda_exec.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:ListTagsForResource"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# resource "aws_iam_role_policy" "lambda_rds_aurora" {
#   name = "lambda_rds_aurora_policy"
#   role = aws_iam_role.lambda_exec.name

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "rds:ModifyDBClusterInstance",
#           "rds:DescribeDBClusterInstances",
#           "rds:DescribeDBClusters"
#         ],
#         Effect   = "Allow",
#         Resource = "*"
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Event Rules (Cron)
resource "aws_cloudwatch_event_rule" "scale_up" {
  name                = "rds_scale_up_business_hours"
  description         = "Scale RDS replica up at 8 AM UTC"
  schedule_expression = "cron(0 6 ? * MON-FRI *)"  # 6 AM UTC = 11.30 AM IST, Mon-Fri
}

resource "aws_cloudwatch_event_rule" "scale_down" {
  name                = "rds_scale_down_off_hours"
  description         = "Scale RDS replica down at 6 PM UTC"
  schedule_expression = "cron(0 15 ? * MON-FRI *)"  # 3:00 PM UTC = 8:30 PM IST
}

# Trigger Lambda from CloudWatch
resource "aws_cloudwatch_event_target" "scale_up" {
  rule      = aws_cloudwatch_event_rule.scale_up.name
  target_id = "lambda"
  arn       = aws_lambda_function.rds_scaling.arn

  input = jsonencode({ "resource": "rds", "activity": "scale up" })
}

resource "aws_cloudwatch_event_target" "scale_down" {
  rule      = aws_cloudwatch_event_rule.scale_down.name
  target_id = "lambda"
  arn       = aws_lambda_function.rds_scaling.arn

  input = jsonencode({ "resource": "rds", "activity": "scale down" })
}

# Lambda Permissions
resource "aws_lambda_permission" "scale_up" {
  statement_id  = "AllowExecutionFromCloudWatchScaleUp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_scaling.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scale_up.arn
}

resource "aws_lambda_permission" "scale_down" {
  statement_id  = "AllowExecutionFromCloudWatchScaleDown"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_scaling.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scale_down.arn
}