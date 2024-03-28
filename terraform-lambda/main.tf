provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "hello_world" {
  filename      = "lambda.zip"
  function_name = "hello-world-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Federated = "https://token.actions.githubusercontent.com"
        },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
