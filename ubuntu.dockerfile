FROM php:8.4-cli

RUN apt update \
 && apt install --yes \
        bash-completion \
        curl \
        git \
        jq \
        unzip \
        wget \
        software-properties-common

#RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

RUN curl --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg \
 && { \
        echo 'deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ noble unit'; \
        echo 'deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ noble unit'; \
    } > /etc/apt/sources.list.d/unit.list

RUN apt update
RUN apt install --yes unit libc6
RUN apt install --yes unit-php

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/
COPY welcome.* /usr/share/unit/welcome/

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
EXPOSE 80
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]