# GH to AWS S3 Upload Methods

## 1. OIDC Authentication for S3 upload from GH actions

**Start by setting up AWS OpenID Connect Identity Provider<br>**
1. configure OpenID Connect in Amazon Web Services<br>
2. AWS account -> IAM -> Identity providers -> Create Identity Provider -> Select **OpenID connect.**<br>
3. For the **provider URL:** Use https://token.actions.githubusercontent.com<br>
4. For the **“Audience”:**  sts.amazonaws.com<br>
5. Click on Get thumbprint
6. **Github Organization**: Organization1227
7. Leave blank for optional fields
8. Click **Add provider** button.

**Next create IAM role to start using provider which created in previous step<br>**
1. IAM -> Roles -> Create role
2. Select **Web Identity**
3. **Identity provider:** token.actions.githubusercontent.com
4. **Audience**: sts.amazonaws.com
5. Click Next and add permissions as mentioned in next step
6. For AWS S3 Upload select "AmazonS3FullAccess"
7. Click Next
8. Provide ROle Name: **GithubActionhsRole**
9. Check for Trusted Policy under Trusted tab : Automatically generated for the provider
10. Click create Role

**Create S3 bucket<br>**
Example: Bucket policy <br>

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::rdhbucket12/*"
        }
    ]
}
```

**Update "role-to-assume" to use OIDC authentication in workflows**
1. role-to-assume:**arn:aws:iam::12345678:role/gh-role** (Get this ARN from the previous step where IAM role created from that role ARN)
2. permissions:
      id-token: write
      contents: read
   This is manadatory in workflows to be able to request the OIDC JWT ID Token. 
3. aws-region: Mention aws region of the S3 or whatever the resource trying to access through OIDC

## 2. User Access Key and Access ID Authentication Process for S3 upload from GH

**Create User to access first in AWS**
1. IAM -> Users -> click Creat User
2. Enter User Name and click "Next"
3. Permissions: Select "Attach Policies directly" -> Under Permissions Policies -> Select "AmazonS3FullAcess" -> Click "Next" -> Create User  ( user will be able to use S3 for upload throguh GH actions. If we have to acess any other resouces otherthan S3 , samething we need to do.)
4. Got to created user -> Click on "Create Acess Key" -> Application running outside AWS -> Next -> Create access key
5. Make note of Acess Key ID and Acess Key (Need to updated this in GH actions repository secrets)

**Create Policy for S3 Full acess and attach this policy to IAM role**
1. Click Create Policy -> JSON -> Under Add Actions (Right Side) Select S3 -> Select "All action (S3:*)"
2. On Resource in json -> Select S3 on right side -> Click Add Resource -> Drop down for Resources -> Select "All"
3. Click Next -> Enter Policy Name - > Click "Create Policy"
   
**Create IAM role using AWS Account**
1. IAM -> "Roles" -> click "Create role".
2. Choose the trusted entity type as "AWS account" -> Another AWS Account -> Enter same Account ID -> Next
3. Attach policies(created in previuos step) granting necessary permissions for accessing S3. (attach the AmazonS3FullAccess policy for full access to S3.)
4. Click Next - > Enter Role name and click "Create role".
5. Edit the trust relationship policy to trust GitHub Actions (Need to edit the JSON policy to include GitHub Actions as the trusted entity.)
_Trusted Entities_
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::338435713321:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
```
