# AWS Lambda EC2 Rebooter with SNS Notification

This Terraform script sets up an AWS Lambda function which reboots specified EC2 instances and sends an SNS notification to inform users about the reboot. The script also integrates CloudWatch Events to automate the process at specific intervals.

## Features

- **Scheduled Reboot**: Uses AWS CloudWatch Events to schedule the reboot of EC2 instances every Wednesday at 2:11 AM EST.
- **SNS Notification**: After every reboot, an SNS notification is sent, informing users that the EC2 instance has been rebooted.
- **CloudWatch Logging**: The Lambda function logs its activities to AWS CloudWatch, making it easier to debug and monitor.
- **Terraform Managed**: Infrastructure as Code approach to create, modify, and manage AWS resources.

## Prerequisites

- AWS Account.
- Terraform installed on your machine.
- AWS CLI set up with appropriate permissions.
- Your desired EC2 instance IDs and region details.

## Setup

1. Clone the repository to your local machine.
   
   ```bash
   git clone https://github.com/sahibgasimov/ec2_reboot_using_lambda_cloudwatch_rule.git
2. Navigate to the project directory.

   ```bash
   cd ec2_reboot_using_lambda_cloudwatch_rule
   ```
3. Initialize Terraform.
   ```bash
   terraform init
   ```
4. Apply the Terraform plan.

  ```bash
  terraform apply
  ```
Confirm the changes by typing yes when prompted.

Once the process completes, your Lambda function will be set up and ready to reboot the instances at the scheduled time.

### Variables
####region: AWS region where resources will be deployed.
####instance_ids: List of EC2 instance IDs that need to be rebooted.
####account_id: Your AWS account ID.
####sns_topic_arn: ARN of the SNS topic to which notifications should be sent.

### Lambda Function Logic
The core logic of the Lambda function is written in Python. It retrieves the instance IDs and SNS Topic ARN from environment variables. For each instance ID:

### The EC2 instance is rebooted.
An SNS notification is sent.
If there's an error during the reboot, the error is printed and logged in AWS CloudWatch.

### Future Enhancements
Integrate with other notification systems like Slack or Email.
Add more granular control over scheduling.
Add error handling mechanisms for more specific AWS-related errors.


### Error handling

CRON Schedule Explanation
The CloudWatch Event Rule uses a cron expression to determine when to trigger the Lambda function. In this configuration, the cron expression is:

makefile
Copy code
schedule_expression = "cron(10 6 ? * * *)"
This translates to:

10: 10th minute of the hour
6: 6th hour of the day in UTC
?: No specific day of the month
*: Every month
*: Every day of the week
*: Every year
This effectively schedules the event to trigger at 6:10 AM UTC. However, as the desired time is 20:00 PM EST, which is equivalent to 6:10 AM UTC of the next day, this expression effectively covers our requirement of 20:00 PM EST.

Troubleshooting
If something isn't working as expected:

CloudWatch Logs: Check the logs for the Lambda function in CloudWatch. Any errors or print statements from the Lambda function will be captured here.
IAM Permissions: Ensure that the IAM role associated with the Lambda function has the appropriate permissions. Permission issues are a common cause of errors.
Terraform Version: This configuration is designed to work with Terraform version 0.15.1. Using a different version might lead to unexpected issues.
Check CloudWatch Event Rule: Ensure that the CloudWatch event rule is being triggered as expected. You can manually trigger the rule to test the entire flow.
Prerequisites
Terraform v0.15.1
AWS CLI configured with appropriate permissions
An existing SNS topic and subscribed endpoints for receiving notifications
Deployment
Clone this repository.
Initialize Terraform using terraform init.
Plan the deployment using terraform plan to ensure everything looks correct.
Apply the configuration using terraform apply.


