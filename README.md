# GitHub Action for `composer-require-checker`

This repo contains a `Dockerfile` to build https://github.com/maglnet/ComposerRequireChecker/ from scratch. Docker images are also available on the Hub at https://hub.docker.com/r/webfactory/composer-require-checker/tags.

## GitHub Action 

You can run it as a GitHub Action like so:

```yaml
# .github/workflows/check.yml
on: [push]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: ComposerRequireChecker
      uses: docker://webfactory/composer-require-checker:2.0.0
```

To pass a custom config file, add this:
```diff
# .github/workflows/check.yml
on: [push]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: ComposerRequireChecker
      uses: docker://webfactory/composer-require-checker:2.0.0
+      with:
+        args: --config-file=composer-require-checker.js
```

## Docker

You can also run the Docker image in any given directory like this:

`docker run --rm -it -v ${PWD}:/app webfactory/composer-require-checker:2.0.0`
