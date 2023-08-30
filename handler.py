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
            
            # Send an SNS notification
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=f'EC2 instance {instance_id} has been rebooted.',
                Subject='EC2 Reboot Notification'
            )
            
        except Exception as e:
            print(f"Error rebooting instance {instance_id}: {e}")
            raise e  # Raising the exception will ensure that it gets logged in CloudWatch
    
    return {
        'statusCode': 200,
        'body': f'All specified EC2 instances have been attempted to reboot and SNS notifications sent.'
    }

