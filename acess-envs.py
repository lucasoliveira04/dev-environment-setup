import boto3
import json
from botocore.exceptions import ClientError

def get_secret() -> list:

    secret_name = "prod/config-ambiente"
    region_name = "us-east-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise e

    secret_string = get_secret_value_response['SecretString']
    
    secret_data = json.loads(secret_string)

    for key, value in secret_data.items():
        print(f"{key} = {value}")

    return secret_data

get_secret()