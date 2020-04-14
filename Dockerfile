# Build backend source
FROM composer as backend
WORKDIR /app

COPY composer.json composer.lock /app/
RUN composer install  \
    --ignore-platform-reqs \
    --no-ansi \
    --no-autoloader \
    --no-dev \
    --no-interaction \
    --no-scripts

COPY . /app/
RUN composer dump-autoload --optimize --classmap-authoritative

# Build app image
FROM php:7.4.1-apache-buster as app
#LABEL maintainer=""

RUN apt update && apt -y upgrade && \
     apt install -y \
     libfreetype6-dev \
         libwebp-dev \
         libjpeg62-turbo-dev \
         libpng-dev \
         libgmp-dev libpng-dev libmcrypt-dev libonig-dev && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install \
    gd \
    mbstring \
    opcache \
    pdo_mysql
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN a2enmod rewrite

ADD .docker/build/apache.conf /etc/apache2/sites-available/000-default.conf
ADD .docker/build/php.ini ${PHP_INI_DIR}/conf.d/99-overrides.ini
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn

WORKDIR /app
COPY --from=backend /app /app
RUN chgrp -R www-data /app/storage /app/bootstrap/cache && chmod -R ug+rwx /app/storage /app/bootstrap/cache
EXPOSE 8000
ENV PORT 8000
ENTRYPOINT []
CMD sed -i "s/80/$PORT/g" /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground

