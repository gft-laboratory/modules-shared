import boto3
import json
import urllib3
import traceback

http = urllib3.PoolManager()


def send_response(event, context, status, data, reason=None, physical_id=None):
    """
    Sends a response to the CloudFormation custom resource.
    """
    response_body = {
        "Status": status,
        "Reason": reason or f"See CloudWatch Log Stream: {context.log_stream_name}",
        "PhysicalResourceId": physical_id or event.get("PhysicalResourceId") or context.log_stream_name,
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
        resource_properties = event.get("ResourceProperties", {})
        old_properties = event.get("OldResourceProperties", {})
        domain_id = resource_properties.get("DomainId")
        project_id = resource_properties.get("ProjectId")

        # ID estável para este recurso customizado
        physical_id = f"datazone-associations-{project_id}" if project_id else context.log_stream_name

        # --- CREATE / UPDATE ---
        if request_type in ["Create", "Update"]:

            # --- Assets ---
            assets = resource_properties.get("Assets", [])
            if isinstance(assets, str):
                assets = json.loads(assets)

            for asset in assets:
                print(f"[{request_type}] Processando Asset: {asset['name']}")
                try:
                    datazone_client.create_asset(
                        domainIdentifier=domain_id,
                        name=asset["name"],
                        typeIdentifier=asset["type"],
                        description=asset.get("description", ""),
                        owningProjectIdentifier=project_id,
                        formsInput=[{"formName": "default", "content": "{}"}],
                    )
                except datazone_client.exceptions.ConflictException:
                    print(f"Asset {asset['name']} já existe, ignorando...")
                except Exception as e:
                    print(f"Erro ao criar asset {asset['name']}: {e}")
                    raise

            # --- Associations ---
            associations = resource_properties.get("Associations", [])
            if isinstance(associations, str):
                associations = json.loads(associations)

            if request_type == "Update":
                # Comparar com as associações antigas
                old_associations = old_properties.get("Associations", [])
                if isinstance(old_associations, str):
                    old_associations = json.loads(old_associations)

                old_accounts = {assoc["account_id"] for assoc in old_associations}
                new_accounts = {assoc["account_id"] for assoc in associations}

                removed_accounts = old_accounts - new_accounts
                added_accounts = new_accounts - old_accounts

                print(f"Update detectado. Removendo: {removed_accounts}, adicionando: {added_accounts}")

                # Deletar os shares antigos
                for acc in removed_accounts:
                    share_name = f"dz-assoc-{acc}"
                    try:
                        response = ram_client.get_resource_shares(
                            name=share_name,
                            resourceOwner="SELF"
                        )
                        if response["resourceShares"]:
                            share_arn = response["resourceShares"][0]["resourceShareArn"]
                            print(f"Deletando RAM Share: {share_name} ({share_arn})")
                            ram_client.delete_resource_share(resourceShareArn=share_arn)
                    except Exception as e:
                        print(f"Erro ao deletar share {share_name}: {e}")

                # Criar/atualizar os novos
                for assoc in associations:
                    if assoc["account_id"] in added_accounts:
                        share_name = assoc.get("ram_policy", {}).get("name", f"dz-assoc-{assoc['account_id']}")
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
                            print(f"RAM share {share_name} já existe. Ignorando...")
                        except Exception as e:
                            print(f"Erro criando RAM share {share_name}: {e}")
                            raise

            else:  # Create
                for assoc in associations:
                    share_name = assoc.get("ram_policy", {}).get("name", f"dz-assoc-{assoc['account_id']}")
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
                        print(f"RAM share {share_name} já existe. Ignorando...")
                    except Exception as e:
                        print(f"Erro criando RAM share {share_name}: {e}")
                        raise

            send_response(event, context, "SUCCESS", {"message": f"{request_type} processed"}, physical_id=physical_id)

        # --- DELETE ---
        elif request_type == "Delete":
            print("Processando Delete...")
            associations = resource_properties.get("Associations", [])
            if isinstance(associations, str):
                associations = json.loads(associations)

            for assoc in associations:
                share_name = assoc.get("ram_policy", {}).get("name", f"dz-assoc-{assoc['account_id']}")
                try:
                    response = ram_client.get_resource_shares(
                        name=share_name,
                        resourceOwner="SELF"
                    )
                    if response["resourceShares"]:
                        share_arn = response["resourceShares"][0]["resourceShareArn"]
                        print(f"Deletando RAM share: {share_name} ({share_arn})")
                        ram_client.delete_resource_share(resourceShareArn=share_arn)
                    else:
                        print(f"RAM share {share_name} não encontrado, ignorando.")
                except Exception as e:
                    print(f"Erro deletando RAM share {share_name}: {e}")

            send_response(event, context, "SUCCESS", {"message": "Delete processed"}, physical_id=physical_id)

        else:
            send_response(event, context, "SUCCESS", {"message": "Unknown request type"}, physical_id=physical_id)

    except Exception as e:
        print(f"Erro inesperado: {e}")
        traceback.print_exc()
        send_response(event, context, "FAILED", {"error": str(e)}, reason=str(e))
