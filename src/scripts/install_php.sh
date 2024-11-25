#!/bin/bash

# Define the PHP version as a variable
DEFAULT_PHP_VERSION=8.4

# Array of PHP version + PHP folder ID
PHP_VERSIONS=(
    "8.4:20240924"
    "8.3:20230831"
    "8.2:20220829"
    "8.1:20210902"
    "8.0:20200930"
    "7.4:20190902"
    # "7.3:20180731"
    # "7.2:20170718"
    # "7.1:20160303"
    # "7.0:20151012"
    # "5.6:20131226"
)


for entry in "${PHP_VERSIONS[@]}"; do
    version="${entry%%:*}"
    phpFolderId="${entry##*:}"

    sh ./php/install_php$version.sh

    # add our required xdebug files
    cat /tmp/config/php/general.ini >| /etc/php/$version/fpm/conf.d/01-general.ini
    cat /tmp/config/php/general.ini >| /etc/php/$version/cli/conf.d/01-general.ini
    cat /tmp/config/php/cli.ini >| /etc/php/$version/cli/conf.d/01-general-cli.ini

    cp /tmp/config/php/xdebug-3.ini /etc/php/$version/fpm/conf.d/20-xdebug.ini
    cp /tmp/config/php/xdebug-3.ini /etc/php/$version/cli/conf.d/20-xdebug.ini
    sed "s/__PHP__FOLDER__ID/$phpFolderId/g" /tmp/config/php/xdebug-3.ini > /etc/php/$version/fpm/conf.d/20-xdebug.ini
    sed "s/__PHP__FOLDER__ID/$phpFolderId/g" /tmp/config/php/xdebug-3.ini > /etc/php/$version/cli/conf.d/20-xdebug.ini

    # Add Tideways extension via symlink to the PHP extensions of the current PHP version
    sudo ln -sf /usr/lib/tideways/tideways-php-$version.so /usr/lib/php/$phpFolderId/tideways.so

    cp /tmp/config/php/tideways.ini /etc/php/$version/fpm/conf.d/20-tideways.ini
    cp /tmp/config/php/tideways.ini /etc/php/$version/cli/conf.d/20-tideways.ini
    sed "s/__PHP__FOLDER__ID/$phpFolderId/g" /tmp/config/php/tideways.ini > /etc/php/$version/fpm/conf.d/20-tideways.ini
    sed "s/__PHP__FOLDER__ID/$phpFolderId/g" /tmp/config/php/tideways.ini > /etc/php/$version/cli/conf.d/20-tideways.ini
done

# Set the default PHP version
sudo update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION > /dev/null 2>&1 &

# Restart the default PHP-FPM service
service php$DEFAULT_PHP_VERSION-fpm stop > /dev/null 2>&1
service php$DEFAULT_PHP_VERSION-fpm start
sudo update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION > /dev/null 2>&1

# Ensure the PHP user has rights on the session directory
chown www-data:www-data -R /var/lib/php/sessions