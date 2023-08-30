provider "aws" {
  region = var.region # Choose your desired region
}

locals {
  instance_arns = [for id in var.instance_ids : "arn:aws:ec2:${var.region}:${var.account_id}:instance/${id}"]
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-ec2-reboot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for the Lambda to be able to reboot EC2 and publish to SNS
resource "aws_iam_role_policy" "lambda_ec2_sns_policy" {
  name = "lambda-ec2-reboot-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:RebootInstances"],
        Effect   = "Allow",
        Resource = local.instance_arns
      },
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = var.sns_topic_arn
      }
    ]
  })
}



# Lambda function to reboot EC2 and send SNS
resource "aws_lambda_function" "reboot_lambda" {
  filename      = "./handler.py.zip" # You have to package your lambda code into a ZIP file
  function_name = "rebootEC2AndNotify"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler" # This points to the Python function
  runtime       = "python3.8"    # Set to Python 3.8


  environment {
      variables = {
          sns_topic_arn = var.sns_topic_arn,
          instance_ids  = join(",", var.instance_ids)
      }
  }
}


# CloudWatch event rule to run every Friday at 20:00 pm EST
resource "aws_cloudwatch_event_rule" "every_friday" {
  name                = "every-friday-at-8pm"
  description         = "Fires every Wed at 2:11 AM EST"
  schedule_expression = "cron(10 6 ? * * *)"

}

# CloudWatch event target
resource "aws_cloudwatch_event_target" "reboot_ec2_target" {
  rule      = aws_cloudwatch_event_rule.every_friday.name
  target_id = "RebootEC2Target"
  arn       = aws_lambda_function.reboot_lambda.arn
}

# Allow CloudWatch to trigger Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reboot_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_friday.arn
}


########VARIABLES#####

variable "region" {
  type        = string
  description = "Region to deploy resources"
  default = "us-east-2"
}

variable "instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to reboot"
  default     = ["i-0b72b483a01fe21d4", "i-0bcb2a06384164cb6"] # Add more IDs as needed
}


variable "account_id" {
  type        = string
  description = "instance_id to deploy resources"
  default = "014113799398"
}

variable "sns_topic_arn" {
  type        = string
  description = "instance_id to deploy resources"
  default = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
}

#########LOGS#########

/* resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/rebootEC2AndNotify" # Ensure this matches your Lambda function name
  retention_in_days = 7
} 

# IAM policy to give Lambda permissions to write logs to CloudWatch
resource "aws_iam_policy" "lambda_logging" {
  name        = "LambdaLogging"
  description = "Allow Lambda to write logs to CloudWatch"
  
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = aws_cloudwatch_log_group.lambda_logs.arn
      }
    ]
  })
}

# Attach the logging policy to the Lambda IAM role
resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  policy_arn = aws_iam_policy.lambda_logging.arn
  role       = aws_iam_role.lambda_role.name
}  */



