data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../lambda-email-service"
  output_path = "../terraform/email-service.zip"
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = "sq-terraform-state"
  key    = "email-service.zip"
  source = "${data.archive_file.source.output_path}"
}

resource "aws_lambda_function" "email-service" {
  function_name = "email-service"
  role          = aws_iam_role.email-service-role.arn
  handler       = "index.js"
  s3_bucket   = "sq-terraform-state"
  s3_key      = aws_s3_bucket_object.file_upload.key
  runtime = "nodejs14.x"

  environment {
    variables = {
      BUCKET  = "sqfonts",
      DOMAIN  = "shuangqiu.blog",
      REGION  = var.AWS_REGION,
      SQS_URL = "https://sqs.${var.AWS_REGION}.amazonaws.com/${data.aws_caller_identity.current.account_id}/email-output"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs-lambda" {
  event_source_arn = aws_sqs_queue.email-input-queue.arn
  function_name    = aws_lambda_function.email-service.arn
}