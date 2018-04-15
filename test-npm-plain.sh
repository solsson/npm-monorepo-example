#!/bin/sh
set -x

# Testcase: plain npm install bottom up

function clean {
  rm -r node_modules
  rm package-lock.json
  rm shrinkwrap.yaml
}

cd module-c
clean
npm install
cd ../module-b
clean
npm install
cd ../module-a
clean
npm install
cd ../
