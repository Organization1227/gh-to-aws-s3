# OIDC Authentication for EC2 Provision from GitHub Actions

## Set up AWS OpenID Connect Identity Provider

1. Navigate to your AWS account dashboard.
2. Go to IAM (Identity and Access Management).
3. In the left sidebar, select "Identity providers".
4. Click on "Create Provider" and choose "OpenID Connect".
5. Enter the Provider URL as `https://token.actions.githubusercontent.com` and Audience as `sts.amazonaws.com`.
6. Click "Get thumbprint".
7. Enter your GitHub Organization name (e.g., `Organization1227`) and leave optional fields blank.
8. Click "Add provider".

## Create IAM role to start using provider created in the previous step

1. In IAM, navigate to "Roles" and click "Create role".
2. Select "Web Identity" as the trusted entity type.
3. Choose "token.actions.githubusercontent.com" as the Identity provider.
4. Enter `sts.amazonaws.com` as the Audience.
5. Click "Next" and attach the necessary permissions policy, such as `AmazonEC2FullAccess`.
6. Enter a Role Name, for example, `GithubActionsRole`.
7. Ensure that the "Trusted Policy" is automatically generated for the provider.
8. Click "Create Role".

## tf-example

1. Any changes for EC2 provision under main.tf and variables.tf
2. run time variables added for providing EC2 name as "App Server"
