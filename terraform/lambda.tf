resource "aws_iam_role" "email-service-role" {
  name = "email-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "lambda_function_name"
  role          = aws_iam_role.email-service-role.arn
  handler       = "index.js"

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}