# Define the PHP version as a variable
DEFAULT_PHP_VERSION=8.4


sh ./php/install_php8.4.sh
sh ./php/install_php8.3.sh
sh ./php/install_php8.2.sh
sh ./php/install_php8.1.sh
sh ./php/install_php8.0.sh
sh ./php/install_php7.4.sh
sh ./php/install_php7.3.sh
sh ./php/install_php7.2.sh
sh ./php/install_php7.1.sh
sh ./php/install_php7.0.sh
sh ./php/install_php5.6.sh



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