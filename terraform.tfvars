region               = "us-east-2"
lambda_function_name = "sahib"
account_id           = "014113799398"                         # Add your account number
instance_ids         = ["i-0b29202be55467a40", "i-0b72b483a01fe21d4"] # Add your instance IDs
sns_topic_arn        = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
cron_schedule        = "cron(22 2 ? * MON-FRI *)"

default_tags = {
  Terraform   = "true"
  Environment = "prod"
  Owner       = "your_name"
  # Add more tags as necessary
}


