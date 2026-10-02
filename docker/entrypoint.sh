#!/bin/sh
set -e
if [ "$(id -u)" = "0" ]; then
    mkdir -p /var/www/moodledata /var/www/phpunit_data
    chown -R www-data:www-data /var/www/moodledata /var/www/phpunit_data
    # Apache drops privileges itself; run any other command (CLI scripts) as www-data.
    case "$1" in
        apache2*) ;;
        *) set -- setpriv --reuid=www-data --regid=www-data --init-groups "$@" ;;
    esac
fi
exec docker-php-entrypoint "$@"
