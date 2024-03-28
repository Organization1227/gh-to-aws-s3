provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "hello_world" {
  # Set the necessary Lambda function configurations
  # For example:
  filename      = "index.js"
  function_name = "hello-world-function"
  role          = "arn:aws:iam::338435713321:role/lambda_role" # Replace with the actual ARN of your existing IAM role
  handler       = "index.handler"
  runtime       = "nodejs20.x"
}

output "lambda_function_arn" {
  value = aws_lambda_function.hello_world.arn
}
