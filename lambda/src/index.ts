import { APIGatewayEvent } from "aws-lambda";

const handler = (event: APIGatewayEvent): response => {
  return response({ statusCode: 200, body: "Hello World" });
};

const defaultHeaders = {
  "Content-Type": "text/html"
};

const response = ({
  statusCode,
  headers = defaultHeaders,
  body
}: responseInput): response => {
  return {
    statusCode,
    headers,
    body
  };
};

export { handler };
