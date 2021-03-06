# Testcase: plain pnpm install bottom up
set -x

mkdir -p npm-locks.tmp/module-a npm-locks.tmp/module-b npm-locks.tmp/module-c

function clean {
  MODULE=$(basename $PWD)
  [[ "$PWD" =~ npm-locks.tmp ]] && {
    mv package-lock.json ../../$MODULE/
    cd ../../$MODULE/
  }
  rm package-lock.json
  cp package.json ../npm-locks.tmp/$MODULE/
  cd ../npm-locks.tmp/$MODULE/
}

cd module-c
clean
npm install --production --package-lock-only --ignore-scripts
cd ../module-b
clean
npm install --production --package-lock-only --ignore-scripts
cd ../module-a
clean
npm install --production --package-lock-only --ignore-scripts

[[ "$PWD" =~ npm-locks.tmp ]] && {
  mv package-lock.json ../../$MODULE/
  cd ../../$MODULE/
}
rm -r npm-locks.tmp

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
