FROM ubuntu:20.04

LABEL maintainer="Madalin Ignisca"
LABEL version="3.0.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DEBIAN_FRONTEND=noninteractive
ARG DISTRO=focal
ARG NODE_VERSION=node_14.x
ARG PHP_VERSION=8.0

ADD unminimize /tmp/unminimize
ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
ADD https://deb.nodesource.com/gpgkey/nodesource.gpg.key /tmp/nodesource.gpg.key
ADD https://dl.min.io/client/mc/release/linux-amd64/mc /usr/local/bin/minio

RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
      gnupg \
      software-properties-common \
    && apt-key add /tmp/nodesource.gpg.key \
    && echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get install -y \
      bash-completion \
      build-essential \
      curl \
      git \
      iproute2 \
      iputils-ping \
      iputils-tracepath \
      jq \
      language-pack-en \
      libpng-dev \
      man-db \
      manpages \
      mariadb-client \
      mc \
      nano \
      nodejs \
      openssh-client \
      openssl \
      postgresql-client \
      php${PHP_VERSION}-amqp \
      php${PHP_VERSION}-apcu \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-bz2 \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-decimal \
      php${PHP_VERSION}-ds \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-gmp \
      php${PHP_VERSION}-grpc \
      php${PHP_VERSION}-http \
      php${PHP_VERSION}-imagick \
      php${PHP_VERSION}-imap \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-ldap \
      php${PHP_VERSION}-lz4 \
      php${PHP_VERSION}-mailparse \
      php${PHP_VERSION}-maxminddb \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-mcrypt \
      php${PHP_VERSION}-memcached \
      php${PHP_VERSION}-mongodb \
      php${PHP_VERSION}-msgpack \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-oauth \
      php${PHP_VERSION}-pcov \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-protobuf \
      php${PHP_VERSION}-psr \
      php${PHP_VERSION}-raphf \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-smbclient \
      php${PHP_VERSION}-snmp \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-solr \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-ssh2 \
      php${PHP_VERSION}-tidy \
      php${PHP_VERSION}-uuid \
      php${PHP_VERSION}-vips \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-xhprof \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-xmlrpc \
      php${PHP_VERSION}-yac \
      php${PHP_VERSION}-yaml \
      php${PHP_VERSION}-zip \
      php${PHP_VERSION}-zstd \
      python \
      redis-tools \
      sudo \
      wget \
      whois
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && echo "xdebug.mode=debug\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/zz-ext-xdebug.ini \
         "xdebug.start_with_request=yes\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/zz-ext-xdebug.ini \
         "xdebug.client_port=9000\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/zz-ext-xdebug.ini \
    && mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects \
    && chmod 755 /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/minio

VOLUME /projects
VOLUME /home/${USERNAME}

WORKDIR /projects/workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
