import boto3
import os

def lambda_handler(event, context):
    # AWS SDK for Python (Boto3)
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')

    sns_topic_arn = os.environ['sns_topic_arn']
    instance_ids = os.environ['instance_ids'].split(',')

    messages = []

    for instance_id in instance_ids:
        state = check_instance_state(ec2, instance_id)
        if state == "running":
            try:
                ec2.reboot_instances(InstanceIds=[instance_id])
                messages.append(f"EC2 instance {instance_id} has been rebooted.")
            except Exception as e:
                messages.append(f"Error rebooting EC2 instance {instance_id}: {str(e)}")
        else:
            messages.append(f"EC2 instance {instance_id} is in {state} state and cannot be rebooted.")
    
    # Send consolidated SNS message
    sns.publish(TopicArn=sns_topic_arn, Message="\n".join(messages))

def check_instance_state(ec2, instance_id):
    response = ec2.describe_instances(InstanceIds=[instance_id])
    state = response['Reservations'][0]['Instances'][0]['State']['Name']
    return state
