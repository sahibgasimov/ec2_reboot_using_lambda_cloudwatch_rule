provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

terraform {
  required_version = ">= 0.15.1"
}


locals {
  instance_arns = [for id in var.instance_ids : "arn:aws:ec2:${var.region}:${var.account_id}:instance/${id}"]
}

########################### IAM ROLES AND POLICIES ########################

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-lambda-role"

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
  name = "${var.lambda_function_name}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
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

######################## LAMBDA ######################################


# Lambda function to reboot EC2 and send SNS
resource "aws_lambda_function" "reboot_lambda" {
  filename      = "./handler.py.zip" # You have to package your lambda code into a ZIP file
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler" # This points to the Python function
  runtime       = "python3.8"              # Set to Python 3.8


  environment {
    variables = {
      sns_topic_arn = var.sns_topic_arn,
      instance_ids  = join(",", var.instance_ids)
    }
  }
}

###################### CLOUDWATCH EVENT RULE ##########################


# CloudWatch event rule to trigger lambda based on cronjob 
resource "aws_cloudwatch_event_rule" "every_friday" {
  name                = "${aws_lambda_function.reboot_lambda.function_name}-lambda-trigger"
  schedule_expression = var.cron_schedule

}

# CloudWatch event target
resource "aws_cloudwatch_event_target" "reboot_ec2_target" {
  rule      = aws_cloudwatch_event_rule.every_friday.name
  target_id = "${aws_lambda_function.reboot_lambda.function_name}-lambda-trigger"
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


