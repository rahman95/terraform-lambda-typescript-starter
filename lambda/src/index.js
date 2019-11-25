exports.handler = async event => {
  return sendResponse(200, "Hello World");
};

const sendResponse = (status, body) => {
  const response = {
    statusCode: status,
    headers: {
      "Content-Type": "text/html"
    },
    body: body
  };

  return response;
};
