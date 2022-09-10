# syntax=docker/dockerfile:1
FROM php:8.1-fpm

ARG UID=1000

RUN adduser -u ${UID} --disabled-password --gecos "" usuario \
    && mkdir -p /home/usuario/.ssh \
    && chmod 700 /home/usuario/.ssh \
    && chown -R usuario:usuario /home/usuario/ \
    && true

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get -y update \
    && apt-get install -y nodejs yarn \
    && true

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get install -y \
        bash-completion \
        curl \
        git \
        gnupg \
        less \
        locales \
        make \
        multitail \
        nano \
        procps \
        sudo \
        tzdata \
        unzip \
        vim \
        wget \
        zip \
    && localedef -i es_ES -c -f UTF-8 -A /usr/share/locale/locale.alias es_ES.UTF-8 \
    && true

ENV LANG es_ES.UTF-8
RUN rm /etc/localtime \
    && echo "Europe/Madrid" > /etc/timezone \
    && ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && true

# Install packages and PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions @composer  \
            apcu \
            gd \
            intl \
            mcrypt \
            opcache \
            pcntl \
            pdo \
            pdo_mysql \
            mysqli \
            pdo_pgsql \
            pgsql \
            soap \
            sockets \
            xdebug \
            zip \
    && docker-php-ext-enable --ini-name opcache xdebug \
    # PHP-CS-FIXER global
    && wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O php-cs-fixer \
    && chmod a+x php-cs-fixer \
    && mv php-cs-fixer /usr/local/bin/php-cs-fixer \
    && true

## Configuraciones de PHP
COPY conf.d/* /usr/local/etc/php/conf.d/
COPY conf.d/* /usr/local/etc/php-fpm.d/

## Limpiando cache de apt
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb \
    && true

RUN mkdir /app \
  && chown usuario:usuario /app \
  && sed -i "s/^user = $PARTITION_COLUMN.*/user = usuario/" /usr/local/etc/php-fpm.d/www.conf\
  && sed -i "s/^group = $PARTITION_COLUMN.*/group = usuario/" /usr/local/etc/php-fpm.d/www.conf\
  && true

USER usuario
WORKDIR /app
