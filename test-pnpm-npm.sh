# Testcase: plain pnpm install bottom up
set -x

function clean {
  rm -r node_modules
  rm package-lock.json
  rm shrinkwrap.yaml
}

cd module-c
clean
pnpm install
cd ../module-b
clean
pnpm install
cd ../module-a
clean
pnpm install
cd ../

# top level module is a docker build and thus requires a package-lock.json
cd module-a
npm install --production
cd ../

cat module-a/package-lock.json | grep '": {'
cat module-a/package-lock.json | grep '": {' | grep '"yn"'
[ $? -eq 0 ] && echo "Failed: package-lock.json contains a top level dev dependency" && exit 1
