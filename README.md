# Lambda-Email-Service

## About

Lambda-Email-Service is a serverless application for sending email using AWS Lambda, S3, SQS, SES. It allows the use of customised email template stored in AWS S3 and the AWS SES to send the email generated from the templates. 

## Application Infrastructure
### Terraform

The application infrastructure is provisioned and managed using Terraform and it follows the least privilege principle to grant resources necessary permissions. The file structure of Terraform is here: 

``` lua
terraform
├── lambda-role.tf -- the execution role of lambda
├── lambda.tf -- the lambda function definition
├── provider.tf -- configuration of aws
├── sqs.tf -- the SQS and policy definitions
├── tf-state.tf -- the terraform state stored in S3
├── vars.tf -- the terraform variables
├── versions.tf -- the terraform version
```

## Architecture Diagram
![a (3)](https://user-images.githubusercontent.com/48676973/141960195-327f4f7b-691d-471c-894a-04d660605bf7.png)


## CI/CD

The application uses GitHub Action as the CI/CD tool with [serverless][https://www.serverless.com/] to deploy to the AWS Cloud.
