import base64
from urllib.parse import parse_qs, urlparse

from aws_lambda_powertools.utilities.data_classes import (
    APIGatewayProxyEventV2,
    event_source,
)
from pythonlambdautils import Proxy


@event_source(data_class=APIGatewayProxyEventV2)
def handler(event: APIGatewayProxyEventV2, context=None) -> dict:
    print(event)
    if event.http_method != "POST":
        return {"statusCode": 405, "body": "method not allowed!"}
    if "url" not in event.json_body:
        return {"statusCode": 400, "body": "invalid request!"}
    url = event.json_body["url"]
    url_parts = urlparse(url)
    query_params = parse_qs(url_parts.query)
    base_url = url_parts._replace(query=None).geturl()

    p = Proxy(base_url, params=query_params)
    response = p.get()

    return {
        "statusCode": response.status_code,
        "body": {
            "headers": dict(response.headers),
            "body": response.text,
        },
    }
