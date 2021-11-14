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

resource "aws_iam_policy" "email-service-policy" {
  name        = "email-service-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1636631786373",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::sqfonts/*"
    },
    {
      "Sid": "Stmt1636632026124",
      "Action": [
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:sqs:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:email-input-queue",
        "arn:aws:sqs:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:email-output-queue"
      ]
    },
    {
      "Sid": "Stmt1636632131730",
      "Action": "ses:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "email-service-policy-attach" {
  role       = aws_iam_role.email-service-role.name
  policy_arn = aws_iam_policy.email-service-policy.arn
}