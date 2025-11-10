import boto3
import logging
from botocore.exceptions import ClientError
from datetime import datetime

# Configuração do logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Mapeamento de tipos amigáveis para typeIdentifier do DataZone
TYPE_MAP = {
    "S3_OBJECT": "built-in-s3-object",
    "REDSHIFT_TABLE": "built-in-redshift-table",
    "ATHENA_TABLE": "built-in-athena-table",
    "GLUE_DATABASE": "built-in-glue-database",
    "DATASET": "built-in-dataset",
    "PIPELINE": "built-in-pipeline",
}

def serialize(obj):
    """Garante que datetime seja serializável em JSON"""
    if isinstance(obj, datetime):
        return obj.isoformat()
    return obj

def handler(event, context):
    """
    Lambda para criar assets no DataZone.
    Espera no event:
    {
        "ResourceProperties": {
            "DomainId": "<domain-id>",
            "ProjectId": "<project-id>",
            "Assets": [
                {
                    "name": "<asset-name>",
                    "type": "DATASET" | "PIPELINE" | ...,
                    "description": "...",
                    "formsInput": [...],
                    "metadata": {...},  # usado apenas para logs
                    "tags": {...},      # usado apenas para logs
                },
                ...
            ]
        }
    }
    """
    client = boto3.client("datazone")
    domain_id = event["ResourceProperties"]["DomainId"]
    project_id = event["ResourceProperties"]["ProjectId"]
    assets = event["ResourceProperties"].get("Assets", [])

    responses = []

    if not assets:
        logger.info("Nenhum asset recebido no evento.")
        return {"Status": "SUCCESS", "Assets": responses}

    for asset in assets:
        asset_name = asset.get("name")
        asset_type = asset.get("type", "S3_OBJECT").upper()
        type_id = TYPE_MAP.get(asset_type, TYPE_MAP["S3_OBJECT"])

        if not type_id:
            logger.warning(f"Tipo de asset '{asset_type}' não mapeado. Usando S3_OBJECT como padrão.")
            type_id = TYPE_MAP["S3_OBJECT"]

        # formsInput precisa ser lista
        forms_input = asset.get("formsInput", [])
        if not isinstance(forms_input, list):
            logger.warning(f"formsInput de '{asset_name}' não é lista. Corrigindo para lista vazia.")
            forms_input = []

        try:
            resp = client.create_asset(
                domainIdentifier=domain_id,
                name=asset_name,
                typeIdentifier=type_id,
                owningProjectIdentifier=project_id,
                description=asset.get("description", ""),
                formsInput=forms_input
            )
            logger.info(f"Asset '{asset_name}' criado com sucesso ({type_id}). Metadata e tags: {asset.get('metadata')} | {asset.get('tags')}")
            # Serializa datetime para JSON
            responses.append({k: serialize(v) for k, v in resp.items()})

        except ClientError as e:
            logger.error(f"Falha ao criar asset '{asset_name}': {e}")
            responses.append({"Asset": asset_name, "Error": str(e)})

    return {"Status": "SUCCESS", "Assets": responses}
