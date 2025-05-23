FROM unit:php8.4

RUN apt update \
 && apt install --yes \
    bash-completion \
    curl \
    git \
    jq \
    unzip \
    wget

ADD --chmod=0755 https://github.com/nginx/unit/releases/download/1.34.2/unitctl-1.34.2-x86_64-unknown-linux-gnu /usr/bin/unitctl
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer /usr/bin/composer /usr/bin/
COPY ./bin/ /usr/local/bin/

RUN mv "${PHP_INI_DIR}"/php.ini-production "${PHP_INI_DIR}"/php.ini


RUN install-php-extensions \
    apcu \
    bcmath \
    curl \
    gd \
    http \
    intl \
    json \
    memcached \
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

COPY ./entrypoint.d/*.sh /docker-entrypoint.d/
RUN chmod +x ./docker-entrypoint.d/*.sh

RUN mkdir /app
WORKDIR /app

VOLUME [ "/app", "/var/lib/unit" ]