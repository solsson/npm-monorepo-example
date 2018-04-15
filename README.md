
## Preparation

```
npm install -g npm@5.8.0
npm install -g pnpm@1.40.1
```

## Design goals

 * Support docker-based CI -- fast builds at source changes.
 * Assume sandboxed builds, i.e. dev dependencies can do little harm. Save time by not reviewing.
 * Support [build-contract](https://github.com/Yolean/build-contract) for local testing
   -- again fast builds at source changes.
 * Support monorepo, `file:../[path from repo root]` dependencies in `package.json`

## Use package-lock.json for prod install

Use `npm ci` during docker builds,
from the version controlled [package-lock.json].
Note that `npm ci` does [not have a `--production` mode](https://github.com/npm/npm/issues/20125).
This implies, and indeed requires,
that package-lock.json includes all runtime dependencies.
In a monorepo context this means those of `file:../[sibling]` modules too.

## Use something else for dev

We run `npm install --no-package-lock` for local development.
(Another method would be a [postschrinkwrap](https://docs.npmjs.com/files/package-locks#description) that resets changes).
Two problems with npm install for monorepo: slowness + disk usage.
We might evaluate [pnpm](https://github.com/pnpm/pnpm) which by the way has its own schrinkwrap,
or even [rusn](https://www.npmjs.com/package/@microsoft/rush) or you name it.

## Prod install during docker build

With monorepo you can't have the entire repo as build context, as the context transfer would make all builds slow.
This means that `file:../` dependencies need to be packaged to a location inside the top level module's folder.
