#!/bin/bash
echo "\n---- tests expected to fail ----\n"
set -x
./test-npm-plain.sh
./test-pnpm-lock.sh
./test-pnpm-npm.sh
./test-npm-ci.sh
./test-npm-copylock.sh
echo "\n---- tests expected to pass ----\n"
set -e
./test-pnpm-lockfirst.sh
# this last test should prepare for a build-contract run in module-a in addition to letting dev tests pass
./test-pnpm-build-contract.sh
