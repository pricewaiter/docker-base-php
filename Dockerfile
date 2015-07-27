FROM php:5.6-fpm

# node key verification
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.12.5
ENV NPM_VERSION 2.11.3
ENV DEBIAN_FRONTEND noninteractive

RUN buildDeps='libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libcurl3-gnutls-dev libmemcached-dev' \
    && set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl git ca-certificates \
        nginx \
        $buildDeps \
    && docker-php-ext-install mcrypt mbstring bcmath zip pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apt-get autoremove \
    && pecl install memcached \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
    && npm install -g npm@"$NPM_VERSION"

RUN echo 'extension=memcached.so' > /usr/local/etc/php/conf.d/memcached.ini

WORKDIR /usr/src/app

CMD service nginx start && php-fpm
