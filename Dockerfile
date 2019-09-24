FROM composer:latest as staging

RUN apk --no-cache add git patch
COPY version.patch /version.patch

RUN git clone https://github.com/maglnet/ComposerRequireChecker.git /composer-require-checker
WORKDIR /composer-require-checker
ARG revision=master
ENV COMPOSER_REQUIRE_CHECKER_VERSION=${revision}
RUN git checkout $revision \
    && git describe --tags --dirty=-dev --always > version \
    && echo "Building version $(cat version)" \
    && patch -p1 < /version.patch \
    && composer install --no-progress --no-interaction --no-ansi --no-dev

FROM php:7.2-cli
COPY --from=staging /composer-require-checker /composer-require-checker

RUN mkdir /app
WORKDIR /app
ENTRYPOINT ["/composer-require-checker/bin/composer-require-checker"]
CMD ["check"]

LABEL "com.github.actions.name"="webfactory-composer-require-checker"
LABEL "com.github.actions.description"="Analyze composer dependencies and verify that no unknown symbols are used in the sources of a package"
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/webfactory/docker-composer-require-checker"
LABEL "homepage"="https://github.com/maglnet/ComposerRequireChecker"
LABEL "maintainer"="webfactory GmbH <info@webfactory.de>"