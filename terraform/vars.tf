variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

data "aws_caller_identity" "current" {}
