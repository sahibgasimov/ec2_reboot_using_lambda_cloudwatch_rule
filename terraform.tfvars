region               = "us-east-2"
lambda_function_name = "sahib"
account_id           = ""                         # Add your account number
instance_ids         = ["", ""] # Add your instance IDs
sns_topic_arn        = ""
cron_schedule        = "cron(22 2 ? * MON-FRI *)"

default_tags = {
  Terraform   = "true"
  Environment = "prod"
  Owner       = "your_name"
  # Add more tags as necessary
}


