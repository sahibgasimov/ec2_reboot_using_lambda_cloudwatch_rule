terraform {
  backend "s3" {
    bucket = "seraf-adsadko"
    key    = "test3/aws_cloudwatch_event/terraform.tfstate"
    region = "us-east-2"
  }
}
