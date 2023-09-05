
![tf](https://github.com/sahibgasimov/tf_ec2_reboot_using_lambda_cw_rule/assets/100177153/20fad90f-4358-4b99-b861-6fa192e872ac)

# AWS Lambda EC2 Rebooter with SNS Notification

This Terraform script sets up an AWS Lambda function which reboots specified EC2 instances and sends an SNS notification to inform users about the reboot. The script also integrates CloudWatch Events to automate the process at specific intervals.

## Features

- **Scheduled Reboot**: Uses AWS CloudWatch Events to schedule the reboot of EC2 instances every Wednesday at 2:11 AM EST.
- **SNS Notification**: After every reboot, an SNS notification is sent, informing users that the EC2 instance has been rebooted.
- **CloudWatch Logging**: The Lambda function logs its activities to AWS CloudWatch, making it easier to debug and monitor.
- **Terraform Managed**: Infrastructure as Code approach to create, modify, and manage AWS resources.

## Prerequisites

- AWS Account.
- Terraform version => 0.15.1
- AWS CLI set up with appropriate permissions.
- Your desired EC2 instance IDs and region details.
- Existing SNS topic arn 

## Setup

1. Clone the repository to your local machine.
   
   ```bash
   git clone https://github.com/sahibgasimov/ec2_reboot_using_lambda_cloudwatch_rule.git
   ```
2. Navigate to the project directory.

   ```bash
   cd ec2_reboot_using_lambda_cloudwatch_rule
   ```

   Edit your terraform.tfvars to your 

   ```hcl
   region               = "" # Override the default region
   lambda_function_name = ""
   account_id           = "" # Add your account number
   instance_ids = ["i-xxxxxxx", "i-yyyyyyy"] # Add your instance IDs
   sns_topic_arn = "" #add your sns topic arn here
   cron_schedule = "cron(11 2 ? * WED *)" #set up cron based on your desired time schedule

   default_tags = {
     Terraform   = "true"
     Environment = "prod"
     Owner       = "your_name"
     # Add more tags as necessary
   }
   ```


4. Initialize Terraform.
   
   ```bash
   terraform init
   ```
5. Apply the Terraform plan.
   
   ```bash
   terraform apply -var-file=terraform.tfvars
   ```

Confirm the changes by typing ('yes') when prompted.

Once the process completes, your Lambda function will be set up and ready to reboot the instances at the scheduled time.

## Variables

- **region**: 
  - Description: AWS region where resources will be deployed.

- **instance_ids**: 
  - Description: List of EC2 instance IDs that need to be rebooted.

- **account_id**: 
  - Description: Your AWS account ID.

- **sns_topic_arn**: 
  - Description: ARN of the SNS topic to which notifications should be sent.

- **default_tags**: 
  - Description: These tags will be applied to all created resources.

- **lambda_function_name**: 
  - Description: Add your desired lambda function name.



## Lambda Function Logic

The core logic of the Lambda function is written in Python. It retrieves the instance IDs and SNS Topic ARN from environment variables. For each instance ID:

```python
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')
    
    # Retrieve the EC2 instance IDs and SNS Topic ARN from environment variables
    instance_ids = os.environ['instance_ids'].split(',')
    sns_topic_arn = os.environ['sns_topic_arn']
    
    for instance_id in instance_ids:
        try:
            # Reboot the EC2 instance
            ec2.reboot_instances(InstanceIds=[instance_id])
            
            # Send an SNS notification indicating successful reboot
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=f'EC2 instance {instance_id} has been rebooted.',
                Subject='EC2 Reboot Notification'
            )
            
        except Exception as e:
            print(f"Error rebooting instance {instance_id}: {e}")
            
            # Send an SNS notification indicating the failure
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=f'Error rebooting EC2 instance {instance_id}: {str(e)}',
                Subject='EC2 Reboot Failure Notification'
            )
    
    return {
        'statusCode': 200,
        'body': f'All specified EC2 instances have been attempted to reboot and SNS notifications sent.'
    }
```

## After EC2 instances were rebooted.

An SNS notification is sent. If there's an error during the reboot, the error is printed and logged in AWS CloudWatch.

## CRON Schedule Explanation
The CloudWatch Event Rule uses a cron expression to determine when to trigger the Lambda function. In this configuration, the cron expression is:

   ```bash
   schedule_expression = "cron(10 6 ? * * *)"
   ```

- 10: 10th minute of the hour
- 6: 6th hour of the day in UTC
- ?: No specific day of the month
- *: Every month
- *: Every day of the week
- *: Every year
  
This effectively schedules the event to trigger at 6:10 AM UTC (which will be 20:00 PM EST).

## Troubleshooting

If something isn't working as expected:

- **CloudWatch Logs:** Check the logs for the Lambda function in CloudWatch. Any errors or print statements from the Lambda function will be captured here.

- **IAM Permissions:** Ensure that the IAM role associated with the Lambda function has the appropriate permissions. Permission issues are a common cause of errors.

- **Terraform Version:** This configuration is designed to work with Terraform version 0.15.1. Using a different version might lead to unexpected issues.

- **Check CloudWatch Event Rule:** Ensure that the CloudWatch event rule is being triggered as expected. You can manually trigger the rule to test the entire flow.



