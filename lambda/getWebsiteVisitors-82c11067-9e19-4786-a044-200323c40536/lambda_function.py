import json
import boto3

print('Loading function')
dynamo = boto3.resource('dynamodb')
table = dynamo.Table("website-visitors")

def getItem(): 
    resp = table.get_item(Key={"ID": "1"})
    item = resp.get("Item")
    print(item)
    return item

def lambda_handler(event, context):
    item = getItem()
    visitors = item.get("Visitors")
    print(visitors)
    return {"statusCode": 200, "body": visitors}


    
