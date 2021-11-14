resource "aws_sqs_queue" "email-input-queue" {
  name = "email-input-queue"
}

resource "aws_sqs_queue" "email-output-queue" {
  name = "email-output-queue"
}

resource "aws_sqs_queue_policy" "email-input-queue-policy" {
  queue_url = aws_sqs_queue.email-input-queue.id

  policy = <<POLICY
{
  "Id": "Policy1636797933923",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1636797932169",
      "Action": [
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.email-input-queue.arn}",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "email-output-queue-policy" {
  queue_url = aws_sqs_queue.email-output-queue.id

  policy = <<POLICY
{
  "Id": "Policy1636797933924",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1636797932169",
      "Action": [
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.email-output-queue.arn}",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}