region               = "us-east-1"
lambda_function_name = ""
account_id           = ""                         # Add your account number
instance_ids         = ["i-xxxxxxx", "i-yyyyyyy"] # Add your instance IDs
sns_topic_arn        = ""
cron_schedule        = "cron(11 2 ? * WED *)"

default_tags = {
  Terraform   = "true"
  Environment = "prod"
  Owner       = "your_name"
  # Add more tags as necessary
}


