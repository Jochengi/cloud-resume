import json
import boto3
import os

# Declare DynamoDB client wrapper outside main handler loop to keep database connection warm across multiple web requests
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMO_TABLE', 'cloud-resume-visitor-counter')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
  try:
    # Execute Atomic increment
    response = table.update_item(
      Key={'id': 'visits'},
      UpdateExpression="SET #c = if_not_exists(#c, :start) + :val",
      ExpressionAttributeNames={'#c': 'Count'},
      ExpressionAttributeValues={':val': 1, ':start': 0},
      ReturnValues="UPDATED_NEW"
    )

    updated_count = response['Attributes']['Count']

    return {
      'statusCode': 200,
      'headers': {
        # Allow frontend code to safely talk to API
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type'
      },
      'body': json.dumps({
        'count': int(updated_count)
      })
    }
  
  except Exception as e:
    print(f"Error executing Lambda: {str(e)}")
    return {
      'statusCode': 500,
      'body': json.dumps({'error': 'Internal Server Error'})
    }