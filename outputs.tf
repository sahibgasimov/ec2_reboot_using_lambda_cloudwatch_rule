###############OUTPUTS##################


output "lambda_arn" {
  description = "ARN of the Lambda function for rebooting EC2 instances."
  value       = aws_lambda_function.reboot_lambda.arn
}

output "cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event Rule for triggering the Lambda function."
  value       = aws_cloudwatch_event_rule.every_friday.arn
}

output "lambda_iam_role_arn" {
  description = "ARN of the IAM role used by the Lambda function."
  value       = aws_iam_role.lambda_role.arn
}

