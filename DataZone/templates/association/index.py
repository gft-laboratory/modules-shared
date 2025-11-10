import boto3
import logging
from botocore.exceptions import ClientError

# Configuração do logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Lambda para criar associações de contas via AWS RAM para um domínio DataZone.
    Espera no event:
    {
        "ResourceProperties": {
            "Accounts": [
                {
                    "account_id": "<aws-account-id>",
                    "account_name": "<nome-da-conta>",
                    "domain_arn": "<ARN-do-dominio>"
                },
                ...
            ]
        }
    }
    """
    client = boto3.client("ram")
    accounts = event["ResourceProperties"].get("Accounts", [])

    if not accounts:
        logger.info("Nenhuma conta para associação fornecida")
        return {"Status": "SUCCESS", "Associations": []}

    responses = []

    for acc in accounts:
        account_id = acc.get("account_id")
        account_name = acc.get("account_name", "unknown-account")
        domain_arn = acc.get("domain_arn")

        if not account_id or not domain_arn:
            logger.warning(f"Conta ignorada por faltar account_id ou domain_arn: {acc}")
            continue

        try:
            resp = client.create_resource_share(
                name=f"{account_name}-share",
                resourceArns=[domain_arn],
                principals=[account_id],
                allowExternalPrincipals=True
            )
            # Retornar apenas campos JSON-serializáveis
            serializable_resp = {
                "name": resp.get("name"),
                "resourceShareArn": resp.get("resourceShare", {}).get("resourceShareArn"),
                "status": resp.get("resourceShare", {}).get("status"),
            }
            responses.append(serializable_resp)
            logger.info(f"ResourceShare criado para {account_name} ({account_id}) com sucesso")

        except ClientError as e:
            logger.error(f"Falha ao criar ResourceShare para {account_name} ({account_id}): {e}")
            responses.append({"Account": account_id, "Error": str(e)})

    return {"Status": "SUCCESS", "Associations": responses}
