provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_openid_connect_provider" "github_actions_oidc_provider" {
  # Specify the ARN of your identity provider here
  arn = "arn:aws:iam::338435713321:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_actions_oidc_provider.arn
      },
      Action    = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.github_actions_oidc_provider.url}:sub" = "system:serviceaccount:namespace:serviceaccount"
        }
      }
    }]
  })
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
