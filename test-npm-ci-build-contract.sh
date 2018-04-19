#!/bin/sh

LOCK_STRATEGY=./test-pnpm-build-contract.sh

. $LOCK_STRATEGY

cd module-a
rm -r node_modules
# Pending https://github.com/npm/npm/issues/20125
mv package.json package.actual.json
node -e "let { dependencies } = require('./package.actual.json'); require('fs').writeFileSync('./package.json', JSON.stringify({ dependencies },null,'  '));"
# do the one thing that isn't workaround
build-contract-predockerbuild
npm ci
RESULT=$?
build-contract-postdockerbuild
# Restore pending https://github.com/npm/npm/issues/20125
mv package.actual.json package.json
cd ..
exit $RESULT
