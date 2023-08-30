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


cd path_to_directory


