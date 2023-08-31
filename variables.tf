########VARIABLES#####

variable "region" {
  type        = string
  description = "Region to deploy resources"
  default     = "us-east-2"
}

variable "instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to reboot"
  default     = ["i-0b72b483a01fe21d4", "i-0bcb2a06384164cb6"] # Add more IDs as needed
}


variable "account_id" {
  type        = string
  description = "instance_id to deploy resources"
  default     = "014113799398"
}

variable "sns_topic_arn" {
  type        = string
  description = "instance_id to deploy resources"
  default     = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "cron_schedule" {
  description = "Cron schedule for the CloudWatch event rule"
  type        = string
}
variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}
