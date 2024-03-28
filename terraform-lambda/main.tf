provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello-world-function"
  filename      = "index.js"
  role          = "arn:aws:iam::338435713321:role/lambda_role"
  handler       = "index.handler"
  runtime       = "nodejs14.x"  # Adjust runtime if "nodejs20.x" is not available
}

output "lambda_function_arn" {
  value = aws_lambda_function.hello_world.arn
}
