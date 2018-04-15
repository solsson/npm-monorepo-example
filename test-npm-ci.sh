#!/bin/sh

LOCK_STRATEGY=./test-pnpm-lockfirst.sh

. $LOCK_STRATEGY

cd module-a
rm -r node_modules
npm ci
cd ..
