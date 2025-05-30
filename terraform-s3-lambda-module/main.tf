# data "archive_file" "lambda_zip" {
#   type        = "zip"

#   source_file = "${path.module}/lambda-code/lambda.py"

#   output_path = "${path.module}/lambda.zip"
# }


module "s3_eventbridge_lambda" {
  source = "./module-s3-eventbridge-lambda"

  bucket_name = "rutvik-s3-trigger-bucket"

  lambda_name     = "s3-eventbridge-lambda"
  architectures   = ["arm64"]
  description     = "This is lambda function triggered from event-bridge rule"
  lambda_handler  = "lambda.lambda_handler"
  lambda_runtime  = "python3.10"
  lambda_zip_path = "/home/rutvik.mangukiya@iqinfinite.in/GitHub/terraform-for-devops/terraform-s3-lambda-module/lambda-code/lambda.zip"
  memory_size     = 256
}




# Demo output values 
output "bucket" {
  value = module.s3_eventbridge_lambda.bucket_name
}
output "path" {
  value = module.s3_eventbridge_lambda.lambda_zip_path
}