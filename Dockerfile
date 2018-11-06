FROM node:10.13-stretch

ENV NPM_CONFIG_LOGLEVEL warn
ENV PATH /usr/src/app/node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-cache search php

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        nginx \
        php7.0-curl \
        php7.0-fpm \
        php7.0-gd \
        php7.0-memcached \
        php7.0-mcrypt \
        php7.0-mysql \
        unzip \
    && apt-get purge -y --auto-remove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/nginx/conf.d/default.conf \
    rm -rf /etc/php/7.0/fpm/pool.d \
    && rm -f /etc/nginx/sites-enabled/default \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /usr/src/app

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

CMD nginx -t && service nginx start && php-fpm7.0 -F
