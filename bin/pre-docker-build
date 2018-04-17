#!/bin/sh
# https://github.com/Yolean/build-contract/pull/30

# https://github.com/Yolean/build-contract/pull/30/files#diff-9a789ca1e0c5686f221eaec3bf9dcda7R61
if [ -z ${MONOREPO_DEPS+x} ]; then
  MONOREPO_DEPS=$(grep '"file:../' package.json | awk -F '"' '{ print $4 }')
fi
if [ ! -z "$MONOREPO_DEPS" ]; then
  mkdir -p npm-monorepo
  cp package.json package.json.monorepo-backup
  for DEPFILE in $MONOREPO_DEPS; do
    DEP=$(echo $DEPFILE | awk -F':' '{ print $2 }')
    pushd $DEP
    TARBALL=$(npm pack | tail -n 1)
    popd
    cp -v $DEP/$TARBALL npm-monorepo/
    sed -i "s|$DEPFILE|file:./npm-monorepo/$TARBALL|" package.json
  done
  echo "  --- monorepo compatibility ---  "
  git diff package.json
fi
