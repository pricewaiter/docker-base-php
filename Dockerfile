FROM php:7-apache

RUN apt-get update -yq && apt-get install -yq \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    unzip \
    git \
    ssh \
    curl gnupg \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install exif \
    && docker-php-ext-install zip \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install nodejs -yq \
    && rm -rf /var/lib/apt/lists/* \
    && npm i -g yarn \
    && yarn global add gulp-cli

RUN a2enmod rewrite
