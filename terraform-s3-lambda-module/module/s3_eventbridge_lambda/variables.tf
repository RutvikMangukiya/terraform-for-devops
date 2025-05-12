variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "architectures" {
  default     = null
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]. Removing this attribute, function's architecture stay the same."
  type        = list(string)
}

variable "description" {
  description = "Description of what your Lambda Function does."
  default     = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = string
}

variable "lambda_handler" {
  description = "The function entrypoint in your code."
  default     = ""
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function you are uploading."
  default     = ""
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the zipped Lambda function code"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = 128
  type        = number
}
