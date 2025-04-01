FROM php:8-cli as base
RUN apt-get update && apt-get install -y libzip4

FROM base as build_extensions

RUN apt-get update && apt-get install -y libzip-dev libicu-dev libfreetype-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gettext zip intl gd \
    && docker-php-ext-enable gettext zip intl gd

FROM composer:2 as staging

RUN apk --no-cache add git

WORKDIR /composer-require-checker
ARG VERSION
ENV COMPOSER_REQUIRE_CHECKER_VERSION=${VERSION}
RUN git clone https://github.com/maglnet/ComposerRequireChecker.git /composer-require-checker
RUN git checkout $VERSION \
    && composer install --no-progress --no-interaction --no-ansi --no-dev --no-suggest --ignore-platform-reqs

FROM base

ARG ARCH
COPY --from=build_extensions /usr/lib/${ARCH}-linux-gnu/libjpeg* /usr/lib/${ARCH}-linux-gnu/
COPY --from=build_extensions /usr/lib/${ARCH}-linux-gnu/libpng* /usr/lib/${ARCH}-linux-gnu/
COPY --from=build_extensions /usr/lib/${ARCH}-linux-gnu/libfreetype* /usr/lib/${ARCH}-linux-gnu/
COPY --from=build_extensions /usr/local/lib/php /usr/local/lib/php
COPY --from=build_extensions /usr/local/etc/php /usr/local/etc/php
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
