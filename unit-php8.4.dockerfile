FROM unit:php8.4

RUN apt update \
 && apt install --yes \
    bash-completion \
    curl \
    git \
    jq \
    unzip \
    wget

RUN mv "${PHP_INI_DIR}"/php.ini-production "${PHP_INI_DIR}"/php.ini

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer /usr/bin/composer /usr/bin/

RUN install-php-extensions \
    apcu \
    bcmath \
    curl \
    gd \
    http \
    intl \
    json \
    memc/ached \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    redis \
    xdebug \
    zip

# symfony
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
 && apt install symfony-cli

COPY ./docker/run.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/run.sh

RUN mkdir /app
WORKDIR /app
