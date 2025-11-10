import boto3
import json
import urllib3
import traceback

http = urllib3.PoolManager()

def send_response(event, context, status, data, reason=None):
    """
    Sends a response to the CloudFormation custom resource.
    """
    response_body = {
        "Status": status,
        "Reason": reason or f"See CloudWatch Log Stream: {context.log_stream_name}",
        "PhysicalResourceId": context.log_stream_name,
        "StackId": event.get("StackId"),
        "RequestId": event.get("RequestId"),
        "LogicalResourceId": event.get("LogicalResourceId"),
        "Data": data,
    }

    json_response_body = json.dumps(response_body)
    headers = {
        "content-type": "application/json",
        "content-length": str(len(json_response_body))
    }

    try:
        response = http.request(
            "PUT", event["ResponseURL"], body=json_response_body, headers=headers
        )
        print(f"CloudFormation response status: {response.status}")
    except Exception as e:
        print(f"send_response failed: {e}")

def handler(event, context):
    """
    Main handler for the Lambda function.
    """
    print(f"Received event: {json.dumps(event)}")
    datazone_client = boto3.client("datazone")
    ram_client = boto3.client("ram")

    try:
        request_type = event["RequestType"]
        if request_type in ["Create", "Update"]:
            resource_properties = event["ResourceProperties"]
            domain_id = resource_properties["DomainId"]
            project_id = resource_properties["ProjectId"]

            # --- Processa Assets ---
            assets = resource_properties.get("Assets", [])
            if isinstance(assets, str):
                assets = json.loads(assets)

            for asset in assets:
                print(f"Criando Assets: {asset['name']}")
                datazone_client.create_asset(
                    domainIdentifier=domain_id,
                    name=asset["name"],
                    typeIdentifier=asset["type"],
                    description=asset.get("description", ""),
                    owningProjectIdentifier=project_id,
                    formsInput=[{"formName": "default", "content": "{}"}],
                )

            # --- Processa Associations ---
            associations = resource_properties.get("Associations", [])
            if isinstance(associations, str):
                associations = json.loads(associations)

            for assoc in associations:
                print(f"Processando Associacao de conta: {assoc['account_id']}")
                policy = assoc.get("ram_policy", {})

                share_name = policy.get("name", f"dz-assoc-{assoc['account_id']}")
                description = policy.get("description", "DataZone RAM policy")
                try:
                    ram_client.create_resource_share(
                        name=share_name,
                        allowExternalPrincipals=True,
                        principals=[assoc["account_id"]],
                        resourceArns=[],
                        tags=[{"key": "Environment", "value": assoc.get("environment", "dev")}],
                    )
                    print(f"Created RAM share: {share_name}")
                except ram_client.exceptions.IdempotentParameterMismatchException:
                    print(f"RAM share {share_name} already exists. Skipping creation.")
                except Exception as e:
                    print(f"Error creating RAM share {share_name}: {e}")
                    raise

            send_response(event, context, "SUCCESS", {"message": "Assets and associations processed"})

        elif request_type == "Delete":
            print("Processing Delete request. No specific cleanup implemented in this example.")
            send_response(event, context, "SUCCESS", {"message": "Delete event processed"})
        
        else:
            send_response(event, context, "SUCCESS", {"message": "Unknown request type"})

    except Exception as e:
        print(f"Um erro inesperado aconteceu: {e}")
        traceback.print_exc()
        send_response(event, context, "FAILED", {"error": str(e)}, reason=str(e))