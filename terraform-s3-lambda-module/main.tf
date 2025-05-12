data "archive_file" "lambda_zip" {
  type = "zip"

  source_file = "${path.module}/../lambda/s3_eventbridge_lambda.py"
  output_path = "${path.module}/../s3_eventbridge_lambda.zip"
}

module "s3_eventbridge_lambda" {
  source = "./modules/s3_eventbridge_lambda"

  bucket_name = "my-s3-trigger-bucket"

  lambda_name     = "s3_eventbridge_lambda"
  architectures   = ["arm64"]
  description     = "This is lambda function triggered from event-bridge rule"
  lambda_handler  = "s3_eventbridge_lambda.lambda_handler"
  lambda_runtime  = "python3.10"
  lambda_zip_path = data.archive_file.lambda_zip.output_path
  memory_size     = 256
}
