const defaultHeaders = {
  'Content-Type': 'text/html',
};

const response = ({ statusCode, headers = defaultHeaders, body }: ResponseInput): Response => {
  return {
    statusCode,
    headers,
    body,
  };
};

const handler = (): Response => {
  return response({ statusCode: 200, body: 'Hello World' });
};

export { handler };
