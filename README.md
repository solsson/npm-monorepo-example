
## Preparation

```
npm install -g npm@5.8.0
npm install -g pnpm@1.40.2
npm install -g build-contract@1.3.0
```

## Design goals

 * Support docker-based CI -- fast builds at source changes.
 * Assume sandboxed builds, i.e. dev dependencies can do little harm. Save time by not reviewing.
 * Support [build-contract](https://github.com/Yolean/build-contract) for local testing
   -- again fast builds at source changes.
 * Support monorepo, `file:../[path from repo root]` dependencies in `package.json`
 * It _is_ a feature that our builds will only pass with a good package-lock.json,
   and that we have to run its diffs through PRs, because the introduction of new
   prod dependencies should not be taken lightly.
 * It is also a fature that we don't get all dev dependencies in package-lock.json,
   assuming (as above) that builds are properly sandboxed so we don't need to review libs.

## Use package-lock.json for prod install

Use `npm ci` during docker builds,
from the version controlled [package-lock.json].
Note that `npm ci` does [not have a `--production` mode](https://github.com/npm/npm/issues/20125).
This implies, and indeed requires,
that package-lock.json includes all runtime dependencies.
In a monorepo context this means those of `file:../[sibling]` modules too.

## Use something else for dev

We run `npm install --no-package-lock` for local development.
~~(Another method would be a [postshrinkwrap](https://docs.npmjs.com/files/package-locks#description) that resets changes)~~
we'll probably use --ignore-scripts when we (re)generate package-lock.json.
Two problems with npm install for monorepo: slowness + disk usage.
We might evaluate [pnpm](https://github.com/pnpm/pnpm) which by the way has its own shrinkwrap,
or even [rusn](https://www.npmjs.com/package/@microsoft/rush) or you name it.

## Prod install during docker build

With monorepo you can't have the entire repo as build context, as the context transfer would make all builds slow.
This means that `file:../` dependencies need to be packaged to a location inside the top level module's folder.

## Restriction: one level of monorepo dependencies

There's "libs" and "servcies". Use `peerDependencies` to declare dependencies between libs,
and let services do the `file:../'.
This lets us write monorepo tooling without traversal of monorepo dependency graphs.
It's also a quite useful practice because it encourages dependency injection:
a lib might depend on some other lib's TypeScript types,
but should typically have an API that gets the runtime dependency from the calling service.
