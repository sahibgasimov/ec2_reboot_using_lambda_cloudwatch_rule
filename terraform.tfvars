region               = "us-east-2" # Override the default region
lambda_function_name = "sahib"
account_id           = "014113799398" # Add your account number
instance_ids = ["i-xxxxxxx", "i-yyyyyyy"] # Add your instance IDs
sns_topic_arn = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
cron_schedule = "cron(11 2 ? * WED *)"

default_tags = {
  Terraform   = "true"
  Environment = "prod"
  Owner       = "your_name"
  # Add more tags as necessary
}


