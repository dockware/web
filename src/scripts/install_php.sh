# Define the PHP version as a variable
DEFAULT_PHP_VERSION=8.4

PHP_VERSIONS=("8.4" "8.3" "8.2" "8.1" "8.0" "7.4" "7.3" "7.2" "7.1" "7.0" "5.6")

for version in "${PHP_VERSIONS[@]}"; do
    sh ./php/install_php$version.sh

    # add our required xdebug files
    cat /tmp/config/php/general.ini >| /etc/php/$version/fpm/conf.d/01-general.ini
    cat /tmp/config/php/general.ini >| /etc/php/$version/cli/conf.d/01-general.ini
    cat /tmp/config/php/cli.ini >| /etc/php/$version/cli/conf.d/01-general-cli.ini
    cp /tmp/config/php/xdebug-3.ini /etc/php/$version/fpm/conf.d/20-xdebug.ini
    cp /tmp/config/php/xdebug-3.ini /etc/php/$version/cli/conf.d/20-xdebug.ini
done


# TODO i dont know about this
apt-get remove -y dh-php

# TODO i dont know about this
sudo rm -ff /var/lib/apt/lists/* /var/cache/apt/*


#make sure the installation runs also in default php version
sudo update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION > /dev/null 2>&1 &

# make sure the installation runs using our default php version
service php$DEFAULT_PHP_VERSION-fpm stop > /dev/null 2>&1
service php$DEFAULT_PHP_VERSION-fpm start
sudo update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION > /dev/null 2>&1

# make sure our php user has rights on the session
 chown www-data:www-data -R /var/lib/php/sessions