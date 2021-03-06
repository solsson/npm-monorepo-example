# Testcase: plain pnpm install bottom up
set -x

function clean {
  rm -r node_modules
  rm package-lock.json
  rm shrinkwrap.yaml
  rm -r npm-monorepo
}

cd module-c
#clean
pnpm install
cd ../module-b
#clean
pnpm install
cd ../module-a
clean
build-contract-predockerbuild
npm install --production --package-lock-only --ignore-scripts
build-contract-postdockerbuild
pnpm install
cd ../

cat module-a/package-lock.json | grep '": {'
cat module-a/package-lock.json | grep '": {' | grep '"yn"'
[ $? -eq 0 ] && echo "Failed: package-lock.json contains a top level dev dependency" && exit 1

cat module-a/package-lock.json | grep '": {'
cat module-a/package-lock.json | grep '": {' | grep '"wrappy"'
[ $? -eq 0 ] && echo "Failed: package-lock.json contains a monorepo dependency's dev dependency" && exit 1

cd module-c && npm test
[ $? -ne 0 ] && echo "Dev failed in leaf module" && exit 1
cd ..

cd module-b && npm test
[ $? -ne 0 ] && echo "Dev failed in middle module" && exit 1
cd ..
