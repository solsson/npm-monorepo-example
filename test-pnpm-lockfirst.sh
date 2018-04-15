# Testcase: plain pnpm install bottom up
set -x

function clean {
  rm -r node_modules
  rm package-lock.json
  rm shrinkwrap.yaml
}

cd module-c
clean
npm install --production --package-lock-only
cd ../module-b
clean
npm install --production --package-lock-only
cd ../module-a
clean
npm install --production --package-lock-only
cd ../

cd module-c
pnpm install
cd ../module-b
pnpm install
cd ../module-a
pnpm install
cd ../

cat module-a/package-lock.json | grep '": {'
cat module-a/package-lock.json | grep '": {' | grep '"yn"'
[ $? -eq 0 ] && echo "Failed: package-lock.json contains a top level dev dependency"
