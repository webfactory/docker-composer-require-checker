# GitHub Action for `composer-require-checker`

This repo contains a `Dockerfile` to build https://github.com/maglnet/ComposerRequireChecker/ from scratch. Docker images are also available on the Hub at https://hub.docker.com/r/webfactory/composer-require-checker/tags.

## GitHub Action 

You can run it as a GitHub Action like so:

```yaml
# .github/workflows/check.yml
on: [push, pull_request]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: ComposerRequireChecker
      uses: docker://webfactory/composer-require-checker:3.2.0
```

This configuration will use the pre-built image at the Docker Hub. If you
feel more secure with building the Docker Image ad-hoc from the `Dockerfile`
in this repo, use the following syntax instead.

```diff
# .github/workflows/check.yml
on: [push, pull_request]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: ComposerRequireChecker
-      uses: docker://webfactory/composer-require-checker:3.2.0
+      uses: webfactory/docker-composer-require-checker@0.2.0
```

*Note:* When using the Docker image, the tag refers to the Docker image tag.
When referring to this repo, use a tag or commit hash for the Dockerfile.

*Note:* This will build the Docker image every time your workflow is run.
The build will currently use the `3.2.0` release tag of `ComposerRequireChecker`,
which is the latest version as of writing.

In either case, to pass a custom config file, add this:

```diff
# .github/workflows/check.yml
on: [push]
name: Main
jobs:
  composer-require-checker:
    name: ComposerRequireChecker
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: ComposerRequireChecker
      uses: docker://webfactory/composer-require-checker:3.2.0
+      with:
+        args: --config-file=composer-require-checker.js
```

## Docker

Apart from GitHub Actions, you can run the Docker image in any given
directory:

`docker run --rm -it -v ${PWD}:/app webfactory/composer-require-checker:3.2.0`

## Credits, Copyright and License

This action was written by webfactory GmbH, Bonn, Germany. We're a software development
agency with a focus on PHP (mostly [Symfony](http://github.com/symfony/symfony)). If you're a
developer looking for new challenges, we'd like to hear from you!

- <https://www.webfactory.de>
- <https://twitter.com/webfactory>

Copyright 2019 – 2021 webfactory GmbH, Bonn. Code released under [the MIT license](LICENSE).
