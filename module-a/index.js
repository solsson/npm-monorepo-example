const b = require('module-b');
const abbrev = require('abbrev');

const http = require('http');
const port = 31234;

const requestHandler = (request, response) => {
  console.log(request.url);
  response.end('Hello Node.js Server!\n');
};

const server = http.createServer(requestHandler);

server.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err);
  }

  console.log(`server is listening on ${port}`);
});
