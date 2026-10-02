FROM php:8.3-apache AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
        libicu-dev libpq-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
        libxml2-dev libonig-dev libsodium-dev unzip ghostscript poppler-utils \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" intl pgsql pdo_pgsql zip gd soap exif opcache sodium \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && a2enmod rewrite headers expires remoteip \
    && rm -rf /var/lib/apt/lists/* /tmp/pear

COPY docker/php.ini /usr/local/etc/php/conf.d/moodle.ini
COPY docker/apache.conf /etc/apache2/conf-enabled/moodle.conf
COPY docker/entrypoint.sh /usr/local/bin/moodle-entrypoint
RUN tr -d '\015' < /usr/local/bin/moodle-entrypoint > /tmp/ep \
 && mv /tmp/ep /usr/local/bin/moodle-entrypoint && chmod +x /usr/local/bin/moodle-entrypoint

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html
ENTRYPOINT ["moodle-entrypoint"]
CMD ["apache2-foreground"]

# Local development: code is bind-mounted, adds composer for PHPUnit.
FROM base AS dev
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Deployable image (default target, must stay last).
FROM base AS prod
COPY --chown=www-data:www-data . /var/www/html
COPY --chown=www-data:www-data docker/config.php /var/www/html/config.php
