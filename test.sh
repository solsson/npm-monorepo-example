#!/bin/bash
echo "\n---- tests expected to fail ----\n"
set -x
./test-npm-plain.sh
./test-pnpm-lock.sh
./test-pnpm-npm.sh
./test-npm-ci.sh
echo "\n---- tests expected to pass ----\n"
set -e
./test-pnpm-lockfirst.sh
