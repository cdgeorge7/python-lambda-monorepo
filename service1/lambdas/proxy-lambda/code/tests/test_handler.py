from unittest import TestCase
from unittest.mock import patch

from aws_lambda_powertools.utilities.data_classes import APIGatewayProxyEventV2
from main import handler


class MockResponse:
    def __init__(self, status_code, headers, text):
        self.status_code = status_code
        self.headers = headers
        self.text = text


class TestHandler(TestCase):
    @patch("main.Proxy.get")
    def test_it_returns_proper_response(self, mock_proxy_get):
        mock_proxy_get.return_value = MockResponse(200, {}, "Hello World")
        event = APIGatewayProxyEventV2(
            {
                "requestContext": {
                    "http": {
                        "method": "POST",
                    },
                },
                "body": '{"url":"https://example.com"}',
            }
        )
        response = handler(event, None)
        self.assertEqual(response["statusCode"], 200)
        self.assertEqual(response["body"], {"headers": {}, "body": "Hello World"})
