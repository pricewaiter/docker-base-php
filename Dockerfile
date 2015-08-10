FROM mhart/alpine-node:0.12.7

COPY MIRRORS.txt /etc/apk/repositories

RUN apk --update add \
    bash \
    curl \
    g++ \
    git \
    make \
    nginx \
    php-bcmath \
    php-cli \
    php-curl \
    php-ctype \
    php-dom \
    php-fpm \
    php-gd \
    php-json \
    php-mcrypt \
    php-openssl \
    php-pdo_mysql \
    php-phar \
    php-zip \
    php-zlib \
    python \
    && rm /var/cache/apk/*

COPY memcached.so /usr/lib/php/modules/memcached.so
COPY libmemcached.so.11.0.0 /usr/lib/libmemcached.so.11
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN echo 'extension=memcached.so' > /etc/php/conf.d/memcached.ini \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /etc/nginx/sites-enabled \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /usr/src/app

CMD service nginx start && php-fpm
