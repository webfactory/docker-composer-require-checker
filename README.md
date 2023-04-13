# GitHub Action for `ComposerRequireChecker`

This repo contains a `Dockerfile` to build https://github.com/maglnet/ComposerRequireChecker/ from scratch.
Docker images are also built weekly by a GitHub Actions workflow and are published on
[ghcr.io](https://github.com/webfactory/docker-composer-require-checker/pkgs/container/composer-require-checker).

## GitHub Action 

You can run a prebuilt image as a GitHub Action as follows:

```yaml
# .github/workflows/check.yml
on: [push, pull_request]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: ComposerRequireChecker
      uses: docker://ghcr.io/webfactory/composer-require-checker:4.5.0
```

Too pass a custom config file, add this:

```diff
# .github/workflows/check.yml
on: [push, pull_request]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: ComposerRequireChecker
      uses: docker://ghcr.io/webfactory/composer-require-checker:4.5.0
+      with:
+        args: --config-file=composer-require-checker.js
```

If you want to use another version than 4.5.0, check
[which images have been built already](https://github.com/webfactory/docker-composer-require-checker/pkgs/container/composer-require-checker).

## Command line usage

Apart from GitHub Actions, you can run the Docker image in any given
directory:

```bash
docker run --rm -it -v ${PWD}:/app ghcr.io/webfactory/composer-require-checker:4.5.0
```

## Building the image yourself

Review and/or tweak the `Dockerfile` as necessary.

Then, run `docker build --build-arg VERSION=4.5.0 --tag composer-require-checker .`. Be sure to set the build argument
to a [valid version number](https://github.com/maglnet/ComposerRequireChecker/tags).

To use your own image, use `composer-require-checker` instead of `ghcr.io/webfactory/composer-require-checker` in the
commands from the previous section.

## Credits, Copyright and License

This action was written by webfactory GmbH, Bonn, Germany. We're a software development
agency with a focus on PHP (mostly [Symfony](http://github.com/symfony/symfony)). If you're a
developer looking for new challenges, we'd like to hear from you!

- <https://www.webfactory.de>
- <https://twitter.com/webfactory>

Copyright 2019 – 2023 webfactory GmbH, Bonn. Code released under [the MIT license](LICENSE).
