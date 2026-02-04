# static website demo via terraform

This repository contains a demo of deploying a static website using Terraform, AWS S3, and CloudFront. The infrastructure is organized using Terraform modules

## website-s3-with-cloudfront

this module is located in `infrastructure/modules/website-s3-with-cloudfront` and creates an S3 bucket to host the static website content and a CloudFront distribution to serve the content globally with low latency acting as the CDN, OAC to securely access the S3 bucket, and Route 53 to manage the DNS records for the website domain. ACM for SSL/TLS certificates is also included.

an example of use is located in `infrastructure/accounts/prd/us-east-1/static-website/`

where the domain name and route53 zone id should be customized to your own domain.
basically each time that the app will be updated the content of the S3 bucket will be replaced with the new build of the app and a cache invalidation will be triggered in CloudFront to ensure that the latest content is served to users.

thats it!
i used the terraform aws modules to simplify the code

## GitHub Actions CI/CD

regarding the ci cd i have created two workflows in `.github/workflows/`
one that builds and deploys the static website content to the S3 bucket
and another one that deploys the infrastructure via terraform using tofu action
i didnt test it so i just created a simple mock of the idea and structure that i will follow
also the terraform backend and iam role to assume when deploying is not specified in the code but i will use s3 backend encrypted with a custom kms key, the Key policy will allow the role to encrypt,decrypt the state via s3. so its a double layer of security above the s3 permissions. the iam role will be assumed via github oidc provider from the github actions workflow.
