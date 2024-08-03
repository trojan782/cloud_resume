import os
import json
import boto3
import logging
from decimal import Decimal

logger = logging.getLogger()
logger.setLevel(logging.INFO)
dynamodb = boto3.resource('dynamodb')

"""
The class below solves a specific problem when working with JSON serialization and dynamodb.
"""
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)
        
def lambda_handler(event, context):
    table = dynamodb.Table('resume-table')

    try:
       
        # Get item from DynamoDB
        # NOTE you use the below to dynamically get the different versions of the json file, based on the id e.g 2, 1 ...
        # response = table.get_item(Key={'id': int(event['id'])}) 
        response = table.get_item(Key={'id': 1})
        
        # Check if item exists in the response
        if 'Item' in response:
            item = response['Item']
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps(item['data'], cls=DecimalEncoder)
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps('Item not found')
            }
    except Exception as e:
        print(e)
        logger.error(f"Error retrieving data:{e}", exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps('Error retrieving data')
        }
