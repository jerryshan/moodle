#!/bin/sh
set -e
mkdir -p /var/www/moodledata /var/www/phpunit_data
chown -R www-data:www-data /var/www/moodledata /var/www/phpunit_data
exec docker-php-entrypoint "$@"
