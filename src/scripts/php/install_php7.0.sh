apt-get install -y  php7.0-fpm \
                    php7.0-apc \
                    php7.0-apcu \
                    php7.0-curl \
                    php7.0-cli \
                    php7.0-gd \
                    php7.0-json \
                    php7.0-ldap \
                    php7.0-mysql \
                    php7.0-pgsql \
                    php7.0-gettext \
                    php7.0-intl \
                    php7.0-xml \
                    php7.0-mysql \
                    php7.0-mbstring \
                    php7.0-zip \
                    php7.0-soap \
                    php7.0-memcached \
                    php7.0-redis \
                    php7.0-bcmath \
                    php7.0-imap \
                    php7.0-ssh2 \
                    dh-php \
                    php7.0-geoip \
                    php7.0-amqp \
                    php7.0-xdebug \
                    php7.0-mongo


cat /tmp/config/php/general.ini >| /etc/php/7.0/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/7.0/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/7.0/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini