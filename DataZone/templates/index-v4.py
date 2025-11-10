import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Handler simples que recebe o payload direto (via aws_lambda_invocation ou teste manual)
    e executa as operações desejadas.
    """

    logger.info("Evento recebido: %s", json.dumps(event))

    try:
        request_type = event.get("RequestType")
        domain_id = event["ResourceProperties"]["DomainId"]
        project_id = event["ResourceProperties"]["ProjectId"]
        associations = event["ResourceProperties"].get("Associations", [])

        # Aqui você coloca a lógica real de criação/associação
        if request_type == "Create":
            logger.info(f"Criando assets no domínio {domain_id}, projeto {project_id}")
            logger.info(f"Associations: {associations}")

            # Exemplo: chamar DataZone API / boto3
            # client = boto3.client("datazone")
            # response = client.create_asset(...)  # Exemplo fictício
            response = {"status": "ASSETS_CREATED", "domain": domain_id, "project": project_id}

        elif request_type == "Delete":
            logger.info(f"Removendo assets do domínio {domain_id}, projeto {project_id}")
            response = {"status": "ASSETS_DELETED", "domain": domain_id, "project": project_id}

        else:
            response = {"status": "NO_ACTION", "message": f"RequestType {request_type} não reconhecido"}

        return {
            "Status": "SUCCESS",
            "RequestType": request_type,
            "Data": response
        }

    except Exception as e:
        logger.error("Erro ao processar evento", exc_info=True)
        return {
            "Status": "FAILED",
            "Error": str(e)
        }
