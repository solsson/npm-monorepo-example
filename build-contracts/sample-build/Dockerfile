# A build-contract build can not rely on volumes, so here we COPY instead
FROM solsson/build-contract

# Build context must be the monorepo root, as is the git clone used during CI
COPY . /source

# This is the module to be built, with a dockerfile and its own build-contracts folder
WORKDIR /source/module-a
