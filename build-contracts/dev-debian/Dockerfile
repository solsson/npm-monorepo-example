FROM yolean/node@sha256:f033123ae2292d60769e5b8eff94c4b7b9d299648d0d23917319c0743029c5ef

RUN npm -version; \
  npm install -g npm@5.8.0; \
  npm install -g pnpm@1.40.1;

COPY . /workspace
WORKDIR /workspace
