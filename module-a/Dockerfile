FROM yolean/node-kafka-cache@sha256:05869d8bc811c76e1d4d362db7bbdedc76b458c6df32fb8aac8f2a75e904a347 \
  AS prod
WORKDIR /usr/src/app

COPY package-lock.json npm-monorepo/ci/ ./

# debug
RUN ! grep -E "(mocha|chai|jest|babel)" package-lock.json

RUN npm ci

# monorepo deps above exclude source, to be cacheable, but we do need source in prod
COPY npm-monorepo/*.tgz ./npm-monorepo/
RUN find npm-monorepo/ -name *.tgz -exec npm install --ignore-scripts --no-save --no-package-lock --no-shrinkwrap file:'{}' \;

FROM yolean/node-kafka-cache@sha256:05869d8bc811c76e1d4d362db7bbdedc76b458c6df32fb8aac8f2a75e904a347 \
  AS dev
WORKDIR /usr/src/app

# We want this step cached across all services, i.e. not after package.json copy, or we'll just remove it
# Should we use a package-lock.json instead, for full determinism?
RUN npm install \
  typescript@2.8.3 \
  ts-node@6.0.0 \
  jest@22.4.3 \
  ts-jest@22.4.4 \
  nodemon@1.17.3

RUN du -sh node_modules/* > node_modules_devshared.txt

COPY --from=prod /usr/src/app/node_modules/ ./node_modules/

RUN du -sh node_modules/* > node_modules_devprod.txt; \
  ! diff -u node_modules_devshared.txt node_modules_devprod.txt

COPY npm-monorepo/package.json ./
COPY npm-monorepo ./npm-monorepo

RUN npm install --only=dev --no-shrinkwrap --no-optional

RUN du -sh node_modules/* > node_modules_dev.txt; \
  ! diff -u node_modules_devshared.txt node_modules_dev.txt

COPY . .

# Fixes "jest-haste-map: @providesModule naming collision: Duplicate module name"
RUN rm /usr/src/app/npm-monorepo/package.json /usr/src/app/npm-monorepo/ci/package.json

RUN set -ex; \
  ./node_modules/.bin/tsc; \
  npm test; \
  npm run prepare

FROM yolean/node-kafka-cache@sha256:05869d8bc811c76e1d4d362db7bbdedc76b458c6df32fb8aac8f2a75e904a347
WORKDIR /usr/src/app

COPY --from=prod /usr/src/app/node_modules ./node_modules
COPY --from=dev /usr/src/app/dist dist

ENTRYPOINT [ "node", "-r", "source-map-support/register", "./dist/index.js" ]
