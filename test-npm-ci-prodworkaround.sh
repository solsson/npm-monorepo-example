#!/bin/sh

LOCK_STRATEGY=./test-pnpm-lockfirst.sh

. $LOCK_STRATEGY

cd module-a
rm -r node_modules
# Pending https://github.com/npm/npm/issues/20125
mv package.json package.actual.json
node -e "let { dependencies } = require('./package.actual.json'); require('fs').writeFileSync('./package.json', JSON.stringify({ dependencies },null,'  '));"
# This probably won't be needed in docker builds, which is where we want npm ci
# (anyway it didn't solve EEXIST: file already exists, mkdir '/Users/solsson/Yolean/npm-monorepo-example/module-a/node_modules/module-b/node_modules/module-c')
rm -r ../module-b/node_modules
rm -r ../module-c/node_modules
# do the one thing that isn't workaround
npm ci
# Restore pending https://github.com/npm/npm/issues/20125
mv package.actual.json package.json
cd ..
