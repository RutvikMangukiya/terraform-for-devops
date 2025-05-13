resource "aws_iam_role" "s3_eventbridge_role" {
  name = "s3_eventbridge_role"

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
  name        = "iam_policy_for_lambda"
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

resource "aws_iam_role_policy_attachment" "s3_eventbridge_policy_attachment" {
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
  role       = aws_iam_role.s3_eventbridge_role.name
}