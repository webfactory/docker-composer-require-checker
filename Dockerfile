FROM php:8-cli AS base

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd intl gettext zip && rm /usr/local/bin/install-php-extensions

FROM composer:2 AS staging

RUN apk --no-cache add git

WORKDIR /composer-require-checker
ARG VERSION
ENV COMPOSER_REQUIRE_CHECKER_VERSION=${VERSION}
RUN git clone https://github.com/maglnet/ComposerRequireChecker.git /composer-require-checker
RUN git checkout $VERSION \
    && composer install --no-progress --no-interaction --no-ansi --no-dev

FROM base

COPY --from=staging /composer-require-checker /composer-require-checker

COPY memory.ini /usr/local/etc/php/conf.d/memory.ini

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
