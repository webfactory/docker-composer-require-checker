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

Apart from GitHub Actions, you can run the Docker image in any given
directory:

`docker run --rm -it -v ${PWD}:/app webfactory/composer-require-checker:2.0.0`

## Credits, Copyright and License

This action was written by webfactory GmbH, Bonn, Germany. We're a software development
agency with a focus on PHP (mostly [Symfony](http://github.com/symfony/symfony)). If you're a
developer looking for new challenges, we'd like to hear from you!

- <https://www.webfactory.de>
- <https://twitter.com/webfactory>

Copyright 2019 webfactory GmbH, Bonn. Code released under [the MIT license](LICENSE).
