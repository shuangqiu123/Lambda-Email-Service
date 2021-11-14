terraform {
  backend "s3" {
    bucket = "sq-terraform-state"
    key    = "email-service.json"
  }
}