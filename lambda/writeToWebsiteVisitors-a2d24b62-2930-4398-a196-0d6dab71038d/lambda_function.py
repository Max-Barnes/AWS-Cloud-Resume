import json
import boto3
from decimal import Decimal
print('Loading function')
dynamo = boto3.resource('dynamodb')
table = dynamo.Table("website-visitors")

# replace putitem visitors with what is returned from getitem + 1. this will function as a basic visitor counter
def putItem(item):

    visitors = item.get("Visitors") + 1
    visitorItem = {
    "ID": "1",
    "Visitors": Decimal(visitors)
    }
    table.put_item(Item=visitorItem)

def getItem(): 
    resp = table.get_item(Key={"ID": "1"})
    item = resp.get("Item")
    print(item)
    return item

def lambda_handler(event, context):
    putItem(getItem())
    return {"statusCode": 200, "body": "Item Written"}


    
